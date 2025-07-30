//
//  PathfindingSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/6.
//

import Foundation
import SpriteKit
import Combine

/// 依赖注入
protocol PathfindingProvider {
    
    /// 根据当前坐标，获取tile的实际坐标位置
    func converPointForTile(point: CGPoint) -> CGPoint
    /// 是否可行走方法
    func isWalkable(x: Int, y: Int) -> Bool
    /// 设置是否可行走
    func setWalkable(x: Int, y: Int, canWalk: Bool)
    
    /// 添加寻路的路径node
    func addPathNode(pathNode:SKSpriteNode)
    
    /// 实体在场景下的坐标
    func pointFromScene(_ entity: RMEntity) -> CGPoint
}


class PathfindingSystem: System {
    
    
    /// 取消寻路
    var endFindDic:[UUID: Bool] = [:]
    
    var cancellables = Set<AnyCancellable>()

    
    let ecsManager: ECSManager
    let provider: PathfindingProvider
    
    init (ecsManager: ECSManager, provider: PathfindingProvider){
        self.ecsManager = ecsManager
        self.provider = provider
    }
 
}


/// A Star 算法
extension PathfindingSystem {
    /// 将位置转换到网格中
    private func converPointForTile(point: CGPoint) -> CGPoint {
        return provider.converPointForTile(point: point)
    }
    
    /// 取消寻路
    func endFind(task: WorkTask) {
        endFindDic[task.id] = true
    }
    
    func startFind(entity:RMEntity,
                   start:CGPoint,
                   end:CGPoint,
                   task:WorkTask){
        
        if task.isCancel {
            endFindDic[task.id] = false
            ECSLogger.log("寻路系统出问题了 \(entity.name) 💀💀💀 ")
            return
        }
       
        endFindDic[task.id] = false
        
        let tileStart = converPointForTile(point: start)
        let tileEnd = converPointForTile(point: end)
        
        guard let points = findPath(start: tileStart,
                                    end: tileEnd,
                                    entity: entity,
                                    task: task) else {
            ECSLogger.log("寻路失败，没有可达路径")
            endFindDic[task.id] = false
            return
        }
        
        if endFindDic[task.id] == true {
            ECSLogger.log("寻路操作被取消")
            endFindDic[task.id] = false
            return
        }
        
        ECSLogger.log("寻找到了最优路径：\(entity.name)")
        
        var index = 0
        
        /// 寻路的路径
        for point in points {
            /// 第一位和最后一位忽略
            if index == 0 || index == points.count - 1 {
                index += 1
                continue
            }
            let pathNode = SKSpriteNode(color: .white, size: CGSize(width: 15, height: 15))
            pathNode.position = point
            pathNode.zPosition = 1000
            let name = "\(point.x)_\(point.y)"
//            print("pathName: \(name)")
            pathNode.name = name
            provider.addPathNode(pathNode: pathNode)
            index += 1

        }
        
        /// 找到路径，可以开始走了
        RMEventBus.shared.requestMoveTask(points: points, entity: entity, task: task)
    }
    
    /// A Star 算法
    func findPath(start: CGPoint, end: CGPoint, entity: RMEntity,task: WorkTask) -> [CGPoint]? {
        let startX = Int(start.x)
        let startY = Int(start.y)
        let endX = Int(end.x)
        let endY = Int(end.y)
        
        let openList = AHeap<RMNode> { $0.fCost < $1.fCost || ($0.fCost == $1.fCost && $0.hCost < $1.hCost) }
        var closedSet = Set<RMNode>()
        
        let startNode = RMNode(x: startX, y: startY)
        let endNode = RMNode(x: endX, y: endY)
        
        openList.insert(startNode)
        
        while !openList.isEmpty {
            guard let current = openList.remove() else { break }
            /// 取消寻路
            if endFindDic[task.id] == true {
                ECSLogger.log("因为走了取消寻路方法，导致寻路失败")
                endFindDic[task.id] = false
                return nil
            }
            
            closedSet.insert(current)
            
            if current == endNode {
                return reconstructPath(from: current)
            }
            
            for neighbor in getNeighbors(of: current) {
                if closedSet.contains(neighbor) || !isWalkable(x: neighbor.x, y: neighbor.y){
                    continue
                }
                
                let tentativG = current.gCost + distance(from: current, to: neighbor)
                let openNeighbor = openList.first(where: { $0 == neighbor})
                
                if openNeighbor == nil || tentativG < neighbor.gCost {
                    neighbor.gCost = tentativG
                    neighbor.hCost = distance(from: neighbor, to: endNode)
                    neighbor.parent = current
                    
                    if openNeighbor == nil {
                        openList.insert(neighbor)
                    }
                    
//                    print("g: \(neighbor.gCost)  h: \(neighbor.hCost), f: \(neighbor.gCost + neighbor.hCost)")
                }
            }
        }
        
        return nil
    }
    
    
    /// 周围8个格子
    func getNeighbors(of node:RMNode) -> [RMNode] {
        let directions = [
            (0,1),(1,0),(0,-1),(-1,0), /// 上下左右
            (1,1),(1,-1),(-1,-1),(-1,1) /// 对角线
        ]
        
        var neighbors: [RMNode] = []
        
        for dir in directions {
            let nx = node.x + dir.0 * Int(tileSize)
            let ny = node.y + dir.1 * Int(tileSize)
            if isWalkable(x: nx, y: ny){
                neighbors.append(RMNode(x: nx, y: ny))
            }
        }
        
        return neighbors
    }
    
    /// 是否可通行
    func isWalkable(x: Int, y: Int) -> Bool {
        return provider.isWalkable(x: x, y: y)
    }
    
    /// 曼哈顿距离（启发函数）
    func distance(from: RMNode, to: RMNode) -> Int {
        let dx = abs(from.x - to.x)
        let dy = abs(from.y - to.y)
        return dx + dy
    }
    
    
    /// 回溯路径
    func reconstructPath(from endNode: RMNode) -> [CGPoint] {
        var path: [CGPoint] = []
        var current: RMNode? = endNode
        while let node = current {
            path.append(CGPoint(x: node.x, y: node.y))
            current = node.parent
        }
        
        return path.reversed()
    }
}
