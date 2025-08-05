//
//  RemoveEntityTaskUpdater.swift
//  RimWorld
//
//  Created by wu on 2025/7/30.
//

import Foundation

/// 移除实体，处理任务逻辑
extension TaskSystem {
    
    /// 移除实体
    func removeForRefreshTasks(entity: RMEntity) {
        
        commonRemove(targetEntity: entity)
        
        let type = entity.type
        
        switch type {
            /// 搬运任务
        case kWood:
            /// 新增木头、
            addHaulingTasks(targetEntity: entity)
        case kStorageArea:
            /// 新增存储空间
            addStorage(targetEntity: entity)
        case kBlueprint:
            /// 移除蓝图实体
            removeBlueprint(targetEntity: entity)
        case kGrowingArea:
            /// 移除种植区域
            removeGrowArea(targetEntity: entity)
        default:
            break
        }
        
    }
    
    /// 移除关联任务
    func commonRemove(targetEntity: RMEntity) {
        /// 还没接取的任务，直接删除就好了
        allTaskQueue.removeAll(where: {
            $0.targetEntityID == targetEntity.entityID
        })
        
        for task in doTaskQueue {
            guard task.haulingTask.targetId == targetEntity.entityID else {
                continue
            }
            guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
                ECSLogger.log("移除任务，当前执行人为空💀💀💀")
                continue
            }
        
            /// 强制停止任务
            RMEventBus.shared.requestForceCancelTask(entity: executorEntity, task: task)
        }
    }
    
    
 
}





// MARK: - 蓝图取消任务相关 -
extension TaskSystem {
    
    /// 移除蓝图
    func removeBlueprint(targetEntity: RMEntity) {
        
        guard let blueComponent = targetEntity.getComponent(ofType: BlueprintComponent.self) else { return }
    
        /// 正常建造完成后的移除方法
        if blueComponent.isBuildFinish { return }
        
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        let alreadyMaterials = blueComponent.alreadyMaterials
        
        var index = 0
        let points = getSurroundingPoints(center: targetPoint, distance: tileSize)
        for (type,count) in alreadyMaterials {
            let materialType = MaterialType(rawValue: Int(type)!)
            if count > 0 {
                
                /// 如果大于0，要生成对应的子类实体，位置随机掉落
                var point = targetPoint
                if index < points.count {
                    point = points[index]
                }
                
                switch materialType {
                case .wood:
                    /// 创建木头
                    let params = WoodParams(woodCount: count)
                    RMEventBus.shared.requestCreateEntity(type: kWood, point: point, params: params)
                    
                default:
                    break
                }
                
            }
            
            index += 1
        }
        
    }
    
    /// 九宫格
    private func getSurroundingPoints(center: CGPoint, distance: CGFloat = 32) -> [CGPoint] {
        var points: [CGPoint] = []
        
        for dy in [-1, 0, 1] {
            for dx in [-1, 0, 1] {
                if dx == 0 && dy == 0 { continue } // 跳过中心点
                let point = CGPoint(x: center.x + CGFloat(dx) * distance,
                                    y: center.y + CGFloat(dy) * distance)
                points.append(point)
            }
        }
        
        return points
    }
    
}

// MARK: - 种植区域取消任务相关 -
extension TaskSystem {
    
    /// 移除种植区域
    func removeGrowArea(targetEntity: RMEntity) {
        guard let growComponent = targetEntity.getComponent(ofType: GrowInfoComponent.self) else { return }
        
        let allEntities = growComponent.saveEntities
        let growPoint = PositionTool.nowPosition(targetEntity)
        let points = PositionTool.getAreaAllPoints(size: growComponent.size)
        
        /// 将子视图坐标转换成父视图坐标
        
        for (index,cropID) in allEntities {
            let cropEntity = ecsManager.getEntity(cropID) ?? RMEntity()
            let cropPoint = points[index]
            let pointForScene = CGPoint(x: growPoint.x + cropPoint.x, y: growPoint.y + cropPoint.y)
            PositionTool.setPosition(entity:cropEntity, point: pointForScene)
            OwnerShipTool.removeOwner(owned: cropEntity, ecsManager: ecsManager)
            cropEntity.removeComponent(ofType: OwnedComponent.self)
            
            RMEventBus.shared.requestReparentEntity(entity: cropEntity, z: 0, point: pointForScene)
        }
    }
}
