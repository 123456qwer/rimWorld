//
//  TaskSystem+Cutting.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation

/// 砍伐
extension TaskSystem {
    
    /// 砍伐任务
    func generateCuttingTask() {

        let plants = ecsManager.entitiesAbleToBeCut()
        /// 可以砍伐的树
        for plant in plants {
            /// 砍伐任务
            if EntityAbilityTool.ableToMarkCut(plant, ecsManager) {
                addCuttingTask(plant)
            }
        }
        
    }
    
    /// 初始化时分配砍树任务
    func assignInitialCuttingTasks() {
   
    }
    
    
    /// 处理砍伐任务
    func handleCuttingTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }

    
    /// 添加砍伐任务
    @discardableResult
    func addCuttingTask (_ plantEntity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Cutting,
                            targetEntityID: plantEntity.entityID,
                            executorEntityID: 0)
        allTaskQueue.append(task)
        assignTask()
        
        return task
    }
    
    /// 添加采摘任务
    @discardableResult
    func addPickingTask (_ plantEntity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Cutting,
                            targetEntityID: plantEntity.entityID,
                            executorEntityID: 0)
        task.subType = .Pick
        allTaskQueue.append(task)
        assignTask()
        
        return task
    }
    
    /// 取消砍伐任务
    func removeCuttingTask (_ plantEntity: RMEntity) {
        
        removeTaskFromAllTaskQueue(entity: plantEntity)
        
        if let index = doTaskQueue.firstIndex(where: {
            $0.targetEntityID == plantEntity.entityID
        }){
            
            let workTask = doTaskQueue[index]
            workTask.isCancel = true
            let executor = ecsManager.getEntity(workTask.executorEntityID)
            /// 中断之前的执行
            RMEventBus.shared.requestForceCancelTask(entity: executor ?? RMEntity(), task: workTask)
            EntityActionTool.removeTask(entity: executor ?? RMEntity(), task: workTask)
        }
    }
    
  
    
    
    
    /// 砍伐任务
    func addOrCancelCuttingTask (_ plantEntity: RMEntity,
                                 _ canChop: Bool) {
        if canChop == true {
            addCuttingTask(plantEntity)
        }else{
            removeCuttingTask(plantEntity)
        }
    
    }
    
    /// 采摘任务
    func addOrCancelPickingTask (_ plantEntity: RMEntity,
                                 _ canPick: Bool) {
        if canPick == true {
            addPickingTask(plantEntity)
        }else {
            removeCuttingTask(plantEntity)
        }
    }
 

}


/// 执行砍伐任务
extension TaskSystem {
    
    /// 执行砍伐任务
    func doCuttingTask (_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
            ECSLogger.log("砍伐任务未找到执行人，💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("砍伐任务未找到任务目标，💀💀💀")
            if task.isCompleted {
                ECSLogger.log("这个任务已经完成了，为什么没删除呢，💀💀💀")
            }
            return
        }
        
   
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = PositionTool.nowPosition(targetEntity)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
    
}


/// 结束任务
extension TaskSystem {
    /// 中断砍伐任务
    func cancelCutting (entityID: Int,
                        task: WorkTask) {
     
        removeDoTask(task: task)

        guard let plantEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("砍伐中断操作💀💀💀：任务对应的被砍伐实体没有了")
            return
        }
        
        /// 非点击砍伐标记取消任务
        if EntityAbilityTool.ableToMarkCut(plantEntity, ecsManager) {
            allTaskQueue.append(task)
        }
    }
}
