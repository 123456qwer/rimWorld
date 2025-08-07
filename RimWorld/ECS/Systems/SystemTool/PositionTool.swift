//
//  PositionTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 坐标工具类 🚩 -
/// 坐标工具类
struct PositionTool {
    
    /// 当前实体坐标
    static func nowPosition(_ entity: RMEntity) -> CGPoint {
        guard let pos = entity.getComponent(ofType: PositionComponent.self) else {
            return .zero
        }
        return CGPoint(x: pos.x, y: pos.y)
    }
    
    /// 当前实体在scene上的坐标
    static func nowPositionForScene(_ entity: RMEntity,
                                    provider: PathfindingProvider) -> CGPoint {
        return provider.pointFromScene(entity)
    }
    
    /// 实体数组排序，按距离由近到远
    static func sortEntityForDistance(entity: RMEntity, entities:[RMEntity]) -> [RMEntity] {
        
        let targetPos = PositionTool.nowPosition(entity)
        
        return entities.sorted {
            let pos1 = PositionTool.nowPosition($0)
            let pos2 = PositionTool.nowPosition($1)
            let dis1 = MathUtils.distance(targetPos, pos1)
            let dis2 = MathUtils.distance(targetPos, pos2)
            return dis1 < dis2
        }
    }
    
    /// 按需求排序，需求量最小的优先
    /// 按照对目标材料的需求量（越少越优先）对蓝图排序
    static func sortBlueprintEntitiesByNeed(targetEntity: RMEntity,
                                            blueprintEntities: [RMEntity]) -> [RMEntity] {
        
        let materialType = EntityInfoTool.materialType(targetEntity)
        let key = "\(materialType.rawValue)"
        
        func needCount(for blueprint: RMEntity) -> Int {
            guard let blueprintComp = blueprint.getComponent(ofType: BlueprintComponent.self) else {
                return Int.max
            }
            
            let maxNeed = blueprintComp.materials[key] ?? 0
            let already = blueprintComp.alreadyMaterials[key] ?? 0
            let hauling = blueprintComp.alreadyCreateHaulTask[materialType]?.values.reduce(0, +) ?? 0
            
            return max(0, maxNeed - already - hauling)
        }
        
        return blueprintEntities.sorted {
            needCount(for: $0) < needCount(for: $1)
        }
    }

    
    /// 设置当前实体坐标
    static func setPosition( entity: RMEntity,
                             point: CGPoint) {
        guard let pointComponent = entity.getComponent(ofType: PositionComponent.self) else { return }
        pointComponent.x = point.x
        pointComponent.y = point.y
        entity.node?.position = point
    }
    
    /// 当前存储实体空余的坐标
    static func saveAreaEmptyPosition( saveArea: RMEntity) -> CGPoint{
        
        guard let saveComponent = saveArea.getComponent(ofType: StorageInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
        
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                let col = index % cols
                let row = index / cols

                let x = CGFloat(col) * tileSize + 16.0
                let y = CGFloat(row) * -tileSize - 16.0
                return CGPoint(x: x, y: y)
            }
        }
        
        
        return .zero
    }
    
    
    /// 根据size获取区域的所有坐标点
    static func getAreaAllPoints(size: CGSize) -> [CGPoint] {
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        var points:[CGPoint] = []
        for index in 0..<totalTiles {
            let col = index % cols
            let row = index / cols

            let x = CGFloat(col) * tileSize + 16.0
            let y = CGFloat(row) * -tileSize - 16.0
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    /// 根据Index获取位置
    static func growAreaCropPoint(area: RMEntity, key: Int) -> CGPoint {
        guard let saveComponent = area.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        var points:[CGPoint] = []
        for index in 0..<totalTiles {
            let col = index % cols
            let row = index / cols

            let x = CGFloat(col) * tileSize + 16.0
            let y = CGFloat(row) * -tileSize - 16.0
            points.append(CGPoint(x: x, y: y))
        }

        if key < points.count {
            return points[key]
        }else {
            return .zero
        }
    }
    
    /// 当前存储实体空余的坐标
    static func growAreaEmptyPosition( saveArea: RMEntity) -> CGPoint {
        
        guard let saveComponent = saveArea.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
        
        /// 空闲位置
        var point = CGPoint(x: 0, y: 0)
        
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                let col = index % cols
                let row = index / cols

                let x = CGFloat(col) * tileSize + 16.0
                let y = CGFloat(row) * -tileSize - 16.0
                point = CGPoint(x: x, y: y)
                break
            }
        }
        
        /// 转换成实际位置
        let savePoint = PositionTool.nowPosition(saveArea)
        let returnPoint = CGPoint(x: savePoint.x + point.x, y: savePoint.y + point.y)
        
        
        return returnPoint
    }
    
    /// 种植空闲的位置
    static func growAreaEmptyIndex( saveArea: RMEntity) -> Int {
        guard let saveComponent = saveArea.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return 0
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
    
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                return index
            }
        }
        
        return 0
    }
    
}
