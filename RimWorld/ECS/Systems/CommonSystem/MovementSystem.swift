//
//  MovementSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/6.
//

import Foundation
import Combine
import SpriteKit

class MovementSystem: System {
    
    var moveCharacter:[Int:RMEntity] = [:]
    var moveTask:[Int:WorkTask] = [:]
    
    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
    var cancellables = Set<AnyCancellable>()
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        
        self.ecsManager = ecsManager
        
    }
    
    
   
    
    func moveUpdate(currentTick: Int) {
        
        let elapsedTicks = currentTick - lastProcessedTick
        lastProcessedTick = currentTick
        

        /// 没有可移动的角色
        guard !moveCharacter.isEmpty else {
            return
        }
        
        for (key,value) in moveCharacter {
            guard let moveComponent = value.getComponent(ofType: MoveComponent.self) else {
                continue
            }
            guard let pointComponent = value.getComponent(ofType: PositionComponent.self) else {
                continue
            }
            guard let taskComponent = value.getComponent(ofType: TaskQueueComponent.self) else {
                continue
            }
        
            if moveComponent.points.count > 0 {
                /// 当前位置
                let currentPosition = CGPoint(x: pointComponent.x, y: pointComponent.y)
                /// 目标位置
                let target = moveComponent.points.first ?? CGPoint(x: 0, y: 0)
                
                let dx = target.x - currentPosition.x
                let dy = target.y - currentPosition.y
                let distance = sqrt(dx * dx + dy * dy)
                
                /// 最后一位，距离应该根据俩个物体的间距来计算，先简单按照32
                // TODO: - 👻👻 后期优化 -
                if moveComponent.points.count == 1 {

                    if distance < tileSize{
                        
                        ECSLogger.log("移动任务结束了，发布移动结束事件 😏")
                        /// 达到后移除位置
                        moveComponent.points.remove(at: 0)
                        
                        guard let task = moveTask[key] else {
                            ECSLogger.log("移动任务结束了，但是未找到对应的任务！💀💀💀")
                            continue
                        }
                        /// 移动事件结束
                        RMEventBus.shared.requestMoveEndTask(entity: value, task: task)
                        
                        continue
                    }
                }else{
                    if distance < 2{
                        /// 移除脚步
                        let point = moveComponent.points.first!
                        let scene = value.node?.parent
                        let pathName = "\(point.x)_\(point.y)"
                        let pathNode = scene?.childNode(withName: pathName)
                     
                        pathNode?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.15),SKAction.removeFromParent()]))
                        
                        /// 达到后移除位置
                        moveComponent.points.remove(at: 0)
                        continue
                    }
                }
                
                
                let dir = CGVector(dx: dx / distance, dy: dy / distance)
                let speed = moveComponent.speed
                let moveDistance = speed * Double(elapsedTicks)
                let moveX = currentPosition.x + dir.dx * moveDistance
                let moveY =  currentPosition.y + dir.dy * moveDistance
                
                pointComponent.x = moveX
                pointComponent.y = moveY
                pointComponent.z = maxZpoint - moveY
                
                value.node?.position = CGPoint(x: moveX, y: moveY)
                value.node?.zPosition = maxZpoint - moveY
            }else {
                moveCharacter.removeValue(forKey: key)
                return
            }
        }
    }

  
    
    /// 切换任务，停止行走，把之前的路径也要清除
    func forceSwitchTask(entityID: Int,task: WorkTask) {
        guard let entity = moveCharacter[entityID] else {
            ECSLogger.log("切换任务，停止行走的操作，没有找到对应的实体")
            return
        }
        guard let moveComponent = entity.getComponent(ofType: MoveComponent.self) else {
            ECSLogger.log("切换任务，停止行走的操作，没有找到实体的移动控件")
            return
        }
        for point in moveComponent.points {
            let scene = entity.node?.parent
            let pathName = "\(point.x)_\(point.y)"
            let pathNode = scene?.childNode(withName: pathName)
            pathNode?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.15),SKAction.removeFromParent()]))
        }
        moveCharacter.removeValue(forKey: entityID)
        ECSLogger.log("强制停止了行走")
    }
 
    /// A*寻路算法，逐帧行走
    func moveAction(points:[CGPoint],
                    entity: RMEntity,
                    task:WorkTask){
        guard let moveComponent = entity.getComponent(ofType: MoveComponent.self) else {
            ECSLogger.log("移动系统出问题了 \(entity.name)")
            return
        }
        
        moveComponent.points = points
        moveCharacter[entity.entityID] = entity
        moveTask[entity.entityID] = task
    }
}
