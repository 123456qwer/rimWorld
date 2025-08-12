//
//  TaskSystem+Eat.swift
//  RimWorld
//
//  Created by wu on 2025/8/5.
//

import Foundation

/// 饥饿值降低到一定程度，触发吃饭任务
extension TaskSystem {
    
    /// 新增吃饭任务
    @discardableResult
    func addEatTask(_ entity: RMEntity) -> WorkTask{
        
        
        let task = WorkTask(type: .None,
                            targetEntityID: entity.entityID,
                            executorEntityID: entity.entityID)
        task.hightType = .Eat
        allTaskQueue.append(task)
        assignTask(executorEntity: entity)
        return task
    }
    
    
    /// 处理吃饭任务
    func handleEatTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
    
}




/// 执行吃饭任务
extension TaskSystem {
    
    func doEatTask(_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntityNode(task.executorEntityID)?.rmEntity else {
            ECSLogger.log("修养任务执行人未找到")
            return
        }
        
      
        
        
        
        
    }
    
}
