//
//  CharacterTaskSystem+Cutting.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation

/// 砍伐
extension CharacterTaskSystem {
    
    /// 砍伐任务
    func generateCuttingTask() {

        let trees = ecsManager.entitiesAbleToBeCut()
        /// 可以砍伐的树
        for tree in trees {
            guard let treeComponent = tree.getComponent(ofType: PlantBasicInfoComponent.self) else {
                ECSLogger.log("此树没有基础组件：\(tree.name)")
                continue
            }
            
            /// 初始化时，直接所有都可以砍
            treeComponent.choppedEntityID = 0
            
            /// 砍伐任务
            if treeComponent.canChop == true {
                addCuttingTask(tree)
            }
        }
        
    }
    
    /// 初始化时分配砍树任务
    func assignInitialCuttingTasks() {
        let treeTasks = taskQueue.filter { $0.type == .Cutting }
        let ableToCut = ecsManager.entitiesAbleToCut()
        
        guard !treeTasks.isEmpty else { return }
        guard !ableToCut.isEmpty else { return }

        assignTaskForAbleEntities(ableEntities: ableToCut, ableTasks: treeTasks)
    }

    
    /// 添加砍伐任务
    func addCuttingTask (_ tree: RMEntity) {
        
        guard let treeComponent = tree.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("此树没有基础组件：\(tree.name)")
            return
        }
        
        treeComponent.canChop = true
      
        /// 将砍树任务添加进任务队列
        let task = WorkTask(type: .Cutting,
                            targetEntityID: tree.entityID,
                            executorEntityID: 0)
        taskQueue.append(task)
        sortTaskQueue()
    }
    
   
    
    
    /// 砍伐任务
    func addOrCancelCuttingTask (_ entity: RMEntity,
                                 _ canChop: Bool) {
        
        if entity.getComponent(ofType: PlantBasicInfoComponent.self) != nil{
            if canChop == true {
                addCuttingTask(entity)
            }else{
                removeCuttingTask(entity)
            }
        }else{
            ECSLogger.log("此植物没详情组件")
        }
    }
    
   
    /// 处理砍伐任务
    func handleCuttingTask() {
        
        /// 所有砍伐任务
        let treeTasks = taskQueue.filter{ $0.type == .Cutting }
        guard !treeTasks.isEmpty else { return }
   
        let ableToCut = ecsManager.entitiesAbleToCut()

        /// 空闲实体
        let idleEntity = ableToCut.first { EntityInfoTool.currentTask($0) == nil }
        
        // 如果没有空闲实体，则寻找可以强制切换任务的实体
        let dummyTask = WorkTask(type: .Cutting, targetEntityID: 1, executorEntityID: 1)
        let executor = idleEntity ?? ableToCut.first { 
            EntityAbilityTool.ableForceSwitchTask(entity: $0, task: dummyTask)
        }
        
        /// 可执行人
        guard let executorEntity = executor,
              let executorPosition = executorEntity.getComponent(ofType: PositionComponent.self) else {
            return
        }
     
        /// 执行人位置
        let executorPoint = CGPoint(x: executorPosition.x, y: executorPosition.y)

        // 在所有任务中找到离执行者最近的树
        guard let selectedTask = treeTasks.min(by: { lhs, rhs in
            guard let lhsTree = ecsManager.getEntityNode(lhs.targetEntityID)?.rmEntity,
                  let rhsTree = ecsManager.getEntityNode(rhs.targetEntityID)?.rmEntity,
                  let lhsPos = lhsTree.getComponent(ofType: PositionComponent.self),
                  let rhsPos = rhsTree.getComponent(ofType: PositionComponent.self) else {
                return false
            }

            let lhsDist = MathUtils.distance(executorPoint, CGPoint(x: lhsPos.x, y: lhsPos.y))
            let rhsDist = MathUtils.distance(executorPoint, CGPoint(x: rhsPos.x, y: rhsPos.y))
            return lhsDist < rhsDist
        }) else {
            return
        }
        
        guard let taskComponent = executorEntity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("执行人没有任务组件！💀💀💀")
            return
        }
        
        removeNotDoTask(task: selectedTask)
        doTaskQueue.insert(selectedTask)

        
        /// 执行人当前有其他任务，需要强制转换
        if let execturfirstTask = taskComponent.tasks.first {
            RMEventBus.shared.requestForceSwitchTask(entity: executorEntity, task: execturfirstTask)
            /// 移除之前执行的任务
            EntityActionTool.removeTask(entity: executorEntity, task: execturfirstTask)
        }

        // 分配任务
        selectedTask.executorEntityID = executorEntity.entityID
        
        /// 添加任务
        EntityActionTool.addTask(entity: executorEntity, task: selectedTask)
        /// 执行任务
        EntityActionTool.doTask(entity: executorEntity)
        
       
        ECSLogger.log("角色接取了砍伐任务，放入到了角色的任务队列中！😎😎😎：\(executorEntity.name)")
         
    }
    
    /// 取消砍伐任务
    func removeCuttingTask (_ target: RMEntity) {
        guard let treeComponent = target.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("此树没有基础组件：\(target.name)")
            return
        }
        
        treeComponent.canChop = false
        treeComponent.choppedEntityID = 0
        
        
        /// 没执行的任务列表，直接把任务删除即可
        if let index = taskQueue.firstIndex(where: {
            $0.targetEntityID == target.entityID
        }){
            taskQueue.remove(at: index)
            return
        }
        
        var currentTask:WorkTask?

        /// 如果在正在执行的任务列表中
        if let index = doTaskQueue.firstIndex(where: {
            $0.targetEntityID == target.entityID
        }){
            currentTask = doTaskQueue[index]
            doTaskQueue.remove(at: index)
        }
        
        guard let currentTask = currentTask,
              let executorEntity = ecsManager.getEntity(currentTask.executorEntityID) else {
            return
        }
        
        /// 将任务终止
        RMEventBus.shared.requestForceSwitchTask(entity: executorEntity, task: currentTask)
        /// 移除正在执行的此任务
        EntityActionTool.removeTask(entity: executorEntity, task: currentTask)
    
    }
    
    
    /// 单独个人的砍树任务
    func handleCuttingTaskWithEntity(task: WorkTask,
                                     entity: RMEntity) {
        
        task.executorEntityID = entity.entityID
        EntityActionTool.addTask(entity: entity, task: task)
        EntityActionTool.doTask(entity: entity)
        
        removeNotDoTask(task: task)
        doTaskQueue.insert(task)
    }
    
}


/// 执行砍伐任务
extension CharacterTaskSystem {
    
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
extension CharacterTaskSystem {
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
        
        treeBasicComponent.choppedEntityID = 0
        
        task.isCompleted = false
        task.isInProgress = false
        task.executorEntityID = 0
        

    }
}
