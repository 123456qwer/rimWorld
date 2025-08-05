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

        let trees = ecsManager.entitiesAbleToBeCut()
        /// 可以砍伐的树
        for tree in trees {
            guard let treeComponent = tree.getComponent(ofType: PlantBasicInfoComponent.self) else {
                ECSLogger.log("此树没有基础组件：\(tree.name)")
                continue
            }
    
            /// 砍伐任务
            if treeComponent.canChop == true {
                addCuttingTask(tree)
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
    func addCuttingTask (_ tree: RMEntity) {
        
        let task = WorkTask(type: .Cutting,
                            targetEntityID: tree.entityID,
                            executorEntityID: 0)
        allTaskQueue.append(task)
        assignTask()
    }
    
    /// 取消砍伐任务
    func removeCuttingTask (_ plantEntity: RMEntity) {
        removeTaskFromAllTaskQueue(entity: plantEntity)
        
        if let index = doTaskQueue.firstIndex(where: {
            $0.targetEntityID == plantEntity.entityID
        }){
            
            let workTask = doTaskQueue[index]
            let executor = ecsManager.getEntity(workTask.executorEntityID)
            /// 中断之前的执行
            RMEventBus.shared.requestForceCancelTask(entity: executor ?? RMEntity(), task: workTask)
        }
    }
    
    
    
    /// 砍伐任务
    func addOrCancelCuttingTask (_ plantEntity: RMEntity,
                                 _ canChop: Bool) {
        
        guard let plantComponent = plantEntity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("此植物没详情组件")
            return
        }
        
        plantComponent.canChop = canChop
        
        if canChop == true {
            addCuttingTask(plantEntity)
        }else{
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
     
        
        guard let treeEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("砍伐中断操作💀💀💀：任务对应的被砍伐实体没有了")
            return
        }
        
        guard let treeBasicComponent = treeEntity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("砍伐中断操作💀💀💀：树实体没有对应的基础组件")
            return
        }
        
        
        removeDoTask(task: task)
        allTaskQueue.append(task)
        
    }
}
