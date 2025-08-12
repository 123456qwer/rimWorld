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
    }
    
    /// 移除关联任务
    func commonRemove(targetEntity: RMEntity) {
        /// 还没接取的任务，直接删除就好了
        allTaskQueue.removeAll(where: {
            $0.targetEntityID == targetEntity.entityID
        })
        
        for task in doTaskQueue {
            guard task.haulingTask.targetID == targetEntity.entityID else {
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




