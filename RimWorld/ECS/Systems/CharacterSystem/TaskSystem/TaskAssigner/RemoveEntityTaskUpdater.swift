//
//  RemoveEntityTaskUpdater.swift
//  RimWorld
//
//  Created by wu on 2025/7/30.
//

import Foundation

/// 移除实体，处理任务逻辑
extension CharacterTaskSystem {
    
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
    
    
    /// 移除蓝图
    func removeBlueprint(targetEntity: RMEntity) {
        
        guard let blueComponent = targetEntity.getComponent(ofType: BlueprintComponent.self) else { return }
    
        
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        let alreadyMaterials = blueComponent.alreadyMaterials
        for (type,count) in alreadyMaterials {
            let materialType = MaterialType(rawValue: Int(type)!)
            if count > 0 {
                
                /// 如果大于0，要生成对应的子类实体，位置随机掉落
                let point = CGPoint(x: Int(targetPoint.x) + Int.random(in: -50...50), y: Int(targetPoint.y) + Int.random(in: -50...50))
                
                switch materialType {
                case .wood:
                    /// 创建木头
                    let params = WoodParams(woodCount: count)
                    RMEventBus.shared.requestCreateEntity(type: kWood, point: point, params: params)
                    
                default:
                    break
                }
                
            }
        }
        
        
    }
    
}





// MARK: - 蓝图取消任务相关 -
extension CharacterTaskSystem {
    
    func blueprintRemoveForHauling(task:WorkTask) {
        
    }
    
}
