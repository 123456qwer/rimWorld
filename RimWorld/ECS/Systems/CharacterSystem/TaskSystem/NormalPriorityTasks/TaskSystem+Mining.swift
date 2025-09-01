//
//  TaskSystem+Mining.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 采矿
extension TaskSystem {
    
    func generateMiningTask () {
        
    }
    
    /// 处理挖掘任务
    func handleMiningTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
    
    /// 添加挖掘任务
    @discardableResult
    func addMiningTask (_ entity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Mining,
                            targetEntityID: entity.entityID,
                            executorEntityID: 0)
        allTaskQueue.append(task)
        assignTask()
        
        return task
    }
    
    func removeMiningTask(_ entity: RMEntity) {
        removeTaskFromAllTaskQueue(entity: entity)
        
        if let index = doTaskQueue.firstIndex(where: {
            $0.targetEntityID == entity.entityID
        }){
            
            let workTask = doTaskQueue[index]
            workTask.isCancel = true
            let executor = ecsManager.getEntity(workTask.executorEntityID)
            /// 中断之前的执行
            RMEventBus.shared.requestForceCancelTask(entity: executor ?? RMEntity(), task: workTask)
        }
    }
    
    /// 挖掘任务
    func addOrCancelMiningTask (_ entity: RMEntity,
                                 _ canChop: Bool) {
        if canChop == true {
            addMiningTask(entity)
        }else{
            removeMiningTask(entity)
        }
    
    }
}





extension TaskSystem {
    
    /// 执行挖掘任务
    func doMiningTask (_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
            ECSLogger.log("采矿任务未找到执行人，💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("采矿任务未找到任务目标，💀💀💀")
            if task.isCompleted {
                ECSLogger.log("这个任务已经完成了，为什么没删除呢，💀💀💀")
            }
            return
        }
        
   
        let startPoint = PositionTool.nowPosition(executorEntity)
        var endPoint = PositionTool.nowPosition(targetEntity)
//        endPoint = CGPoint(x: endPoint.x + tileSize, y: endPoint.y + tileSize)
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
}
