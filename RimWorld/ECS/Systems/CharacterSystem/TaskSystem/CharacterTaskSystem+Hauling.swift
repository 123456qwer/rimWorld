//
//  CharacterTaskSystem+Hauling.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 搬运
extension CharacterTaskSystem {
    
    /// 初始化搬运任务
    func generateHaulingTask () {
        
        let hauls = ecsManager.entitiesAbleToBeHaul()
        for entity in hauls {
            addHaulingTask(entity)
        }
    }
    
    // 初始化时分配搬运任务
    func assignInitialHaulingTasks() {
        let haulTasks = taskQueue.filter{ $0.type == .Hauling }
        let ableToHauling = ecsManager.entitiesAbleToHaul()
        
        guard !haulTasks.isEmpty else { return }
        guard !ableToHauling.isEmpty else { return }
        
        assignTaskForAbleEntities(ableEntities: ableToHauling,
                                  ableTasks: haulTasks)
    }
    
    /// 添加搬运任务
    @discardableResult
    func addHaulingTask(_ entity: RMEntity) -> WorkTask? {
        
        /// 已存在
        if haveTaskWithTarget(entity) != nil {
            return nil
        }
        /// 正在执行
        if haveDoTaskWithTarget(entity) != nil {
            return nil
        }
        
        let task = WorkTask(type: .Hauling, targetEntityID: entity.entityID, executorEntityID: 0)
        task.haulStage = .movingToItem
        taskQueue.append(task)
        sortTaskQueue()
        
        return task
    }
    
    /// 建造过程中，搬运任务
    @discardableResult
    func addHaulingTaskForBuild(_ entity: RMEntity,
                                _ blueprintID: Int) -> WorkTask? {
        
        /// 已存在
        if let existingTask = haveTaskWithTarget(entity) {
            existingTask.realType = .Building
            existingTask.targetEntityID2 = blueprintID
            return nil
        }
        
        /// 正在执行
        if haveDoTaskWithTarget(entity) != nil {
            return nil
        }
        
        
        let task = WorkTask(type: .Hauling, targetEntityID: entity.entityID, executorEntityID: 0)
        task.haulStage = .movingToItem
        task.realType = .Building
        task.targetEntityID2 = blueprintID
        taskQueue.append(task)
        sortTaskQueue()
        
        return task
    }
    
    
    /// 执行搬运任务
    func handleHaulingTask(_ task: WorkTask) {
        
        guard let haulEntity = ecsManager.getEntityNode(task.targetEntityID)?.rmEntity else {
            ECSLogger.log("此搬运任务没有实体")
            return
        }
        
        let exectorEntity = ableToDoTaskEntity(ableEntities: ecsManager.entitiesAbleToHaul(), task: task)
        
        /// 如果没有可以执行的角色，直接任务分配失败，还留存在任务列表里
        guard let ableExectorEntity = exectorEntity else {
            ECSLogger.log("当前搬运任务没有任何角色执行！🤕🤕🤕")
            return
        }
        
        guard let taskComponent = ableExectorEntity.getComponent(ofType: TaskQueueComponent.self) else {            ECSLogger.log("当前搬运任务执行人没有任务组件！🤕🤕🤕")
            return
        }
        
        var haulingTargerEntity: RMEntity?
        
        /// 目标区域
        if task.targetEntityID2 != 0 {
            haulingTargerEntity = ecsManager.getEntity(task.targetEntityID2)
        }
        
        /// 最近蓝图
        if haulingTargerEntity == nil {
            haulingTargerEntity = nearestAvailableBlueprint(haulEntity)
        }
        
        /// 存储区域（最后是存储区域）
        if haulingTargerEntity == nil {
            haulingTargerEntity = nearestAvailableStorageArea(haulEntity)
        }
        
        
        
        guard let ableSaveEntity = haulingTargerEntity else {
            ECSLogger.log("当前搬运任务没有任何可达目标！🤕🤕🤕")
            return
        }
        
        /// 执行人当前有其他任务，需要强制转换
        if let execturfirstTask = taskComponent.tasks.first {
            
            RMEventBus.shared.requestForceSwitchTask(entity: ableExectorEntity, task: execturfirstTask)
            /// 移除之前执行的任务
            EntityActionTool.removeTask(entity: ableExectorEntity, task: execturfirstTask)
            
        }
        
  
        
        removeNotDoTask(task: task)
        doTaskQueue.insert(task)
        
        task.executorEntityID = ableExectorEntity.entityID
        task.targetEntityID2 = ableSaveEntity.entityID
        
        
        taskComponent.tasks.insert(task, at: 0)
        EntityActionTool.doTask(entity: ableExectorEntity)
        
        
    }
    
    /// 完成任务后重新分配任务
    func handleHaulingTaskWithEntity(task: WorkTask,
                                     entity:RMEntity) {
        guard let haulEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("搬运物件消失了！💀💀💀")
            return
        }
        let saveAreaEntity = nearestAvailableStorageArea(haulEntity)
        
        guard let ableSaveEntity = saveAreaEntity else {
            ECSLogger.log("当前搬运任务没有任何存储区域可存储！🤕🤕🤕")
            return
        }
        
        task.executorEntityID = entity.entityID
        task.targetEntityID2 = ableSaveEntity.entityID
        
        EntityActionTool.addTask(entity: entity, task: task)
        EntityActionTool.doTask(entity: entity)
        
        removeNotDoTask(task: task)
        doTaskQueue.insert(task)
    }
    
    
    
    /// 获取最近、级别最高的存储区域
    func nearestAvailableStorageArea(_ targetEntity: RMEntity) -> RMEntity? {
        
        guard let targetPointComponent = targetEntity.getComponent(ofType: PositionComponent.self) else {
            return nil
        }
        
        /// 当前要被搬运的目标
        guard let haulComponent = targetEntity.getComponent(ofType: HaulableComponent.self) else {
            ECSLogger.log("当前要被搬运的目标没有搬运组件！💀💀💀")
            return nil
        }
        
        let storageAreas = ecsManager.entitiesAbleToStorage()
        
        /// 先选出所有能存储的区域和设备
        var canStorageAreas:[RMEntity] = []
        for storageArea in storageAreas {
            
            guard let storageComponent = storageArea.getComponent(ofType: StorageInfoComponent.self) else {
                continue
            }
            
            /// 说明可以存储此类型
            if storageComponent.canStorageType[textAction(targetEntity.type)] == true {
                
                /// 在判断当前类型下的数据是否满了
                let size = storageComponent.size
                let cols = Int(size.width / tileSize)
                let rows = Int(size.height / tileSize)
                // 存储区域总格子数
                let totalTiles = abs(cols * rows)
                /// 当前格子上存储的实体
                let storageEntities = storageComponent.saveEntities
                
                /// 存储的位置
                var selectIndex = -1
                
                /// 遍历格子，看是否有能存储的位置
                for index in 0..<totalTiles {
                    /// 存储的实体
                    if let storageEntity = ecsManager.getEntity(storageEntities[index] ?? -1) {
                        /// 存储类型相同
                        if storageEntity.type == targetEntity.type {
                            
                            guard let storageHaulComponent = storageEntity.getComponent(ofType: HaulableComponent.self) else { continue }
                            /// 最大存储
                            let maxLimit = storageHaulComponent.stackLimit
                            /// 当前存储
                            let current = storageHaulComponent.currentCount
                            /// 存满了，直接下一个栏位
                            if maxLimit == current { continue }
                            /// 未存满，但是加上当前要搬运的，大于最大值，直接下一个栏位
                            if current + haulComponent.currentCount > maxLimit { continue }
                        }
                    }
                    
                    selectIndex = index
                    break
                }
                
                /// 不等于-1说明有存储空间
                if selectIndex != -1 {
                    canStorageAreas.append(storageArea)
                }
            }
        }
        
        let targetPoint = CGPoint(x: targetPointComponent.x, y: targetPointComponent.y)
        return bestSaveAreaEntity(from: canStorageAreas, to: targetPoint)
    }
    
    
    /// 获取最近的蓝图区域
    func nearestAvailableBlueprint(_ targetEntity: RMEntity) -> RMEntity?{
        
        guard let categorizationComponent = targetEntity.getComponent(ofType: CategorizationComponent.self) else {
            return nil
        }
        
        let blueprint = ecsManager.entitiesAbleToBeBuild()
        /// 当前材料目标
        let targetType = categorizationComponent.categorization
        
        
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        var distance = 1000000.0
        var targetBlueprint:RMEntity?
        /// 此蓝图
        let haulTasks = taskQueue.filter{ $0.type == .Hauling }
        let doHaulTasks = doTaskQueue.filter{ $0.type == .Hauling }
        
        for (_,blueEntity) in blueprint {
            guard let blueComponent = blueEntity.getComponent(ofType: BlueprintComponent.self) else {
                continue
            }
            var canGo = true
            /// 此蓝图已有对应的任务
            for task in haulTasks {
                if blueEntity.entityID == task.targetEntityID2 {
                    canGo = false
                    break
                }
            }
            /// 此蓝图已有对应的任务
            for task in doHaulTasks {
                if blueEntity.entityID == task.targetEntityID2 {
                    canGo = false
                    break
                }
            }
            
            if canGo == false { continue }
            
            /// 需要的原材料
            for (materialType,valueCount) in blueComponent.alreadyMaterials {
                let maxCount = blueComponent.materials[materialType] ?? 0
                /// 说明这个蓝图缺此材料
                if Int(materialType) == targetType && valueCount < maxCount {
                    let bluePoint = PositionTool.nowPosition(blueEntity)
                    let d = MathUtils.distance(targetPoint, bluePoint)
                    if distance > d {
                        distance = d
                        targetBlueprint = blueEntity
                    }
                }
            }
            
        }
        
       
        
        return targetBlueprint
    }
    
    func bestSaveAreaEntity(from canSaveAreas: [RMEntity], to targetPoint: CGPoint) -> RMEntity? {
        guard !canSaveAreas.isEmpty else { return nil }
        
        var bestEntity: RMEntity?
        var bestDistance: CGFloat = .greatestFiniteMagnitude
        
        // 用于记录当前最高优先级
        var currentPriority: Int?
        
        for entity in canSaveAreas {
            guard
                let saveComponent = entity.getComponent(ofType: StorageInfoComponent.self),
                let positionComponent = entity.getComponent(ofType: PositionComponent.self)
            else {
                continue
            }
            
            // 如果还没设定 currentPriority，就取第一个实体的优先级
            if currentPriority == nil {
                currentPriority = saveComponent.priority
            }
            
            // 如果当前实体优先级低于 currentPriority，说明优先级已经下降，停止遍历
            if saveComponent.priority < currentPriority! {
                break
            }
            
            // 比较距离
            let distance = MathUtils.distance(
                CGPoint(x: positionComponent.x, y: positionComponent.y),
                targetPoint
            )
            
            if distance < bestDistance {
                bestDistance = distance
                bestEntity = entity
            }
        }
        
        return bestEntity
    }
    
    
    /// 是否已有对应的搬运任务
    func haveTaskWithTarget(_ entity: RMEntity) -> WorkTask? {
        /// 先判断下当前搬运任务是否存在于已有的任务队列中
        let haulTasks = taskQueue.filter{ $0.type == .Hauling }
        let doTasks = taskQueue.filter{ $0.type == .Hauling }
        
        /// 说明有这个任务了，直接返回
        for task in haulTasks {
            if task.targetEntityID == entity.entityID {
                return task
            }
        }
        
        return nil
    }
    
    /// 此任务是否已经正在做
    func haveDoTaskWithTarget(_ entity: RMEntity) -> WorkTask? {
        /// 先判断下当前搬运任务是否存在于已有的任务队列中
        let doTasks = doTaskQueue.filter{ $0.type == .Hauling }
        
        /// 说明有这个任务了，直接返回
        for task in doTasks {
            if task.targetEntityID == entity.entityID {
                return task
            }
        }
        
        return nil
    }

}




/// 执行搬运任务
extension CharacterTaskSystem {
    
    /// 搬运任务
    func doHaulingTask(_ task: WorkTask) {
        /// 被搬运目标
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("搬运目标为空！💀💀💀")
            return
        }
        /// 搬运人
        guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
            ECSLogger.log("搬运人为空！💀💀💀")
            return
        }
        /// 搬运目的地
        guard let saveEntity = ecsManager.getEntity(task.targetEntityID2) else {
            ECSLogger.log("搬运目的地为空！💀💀💀")
            return
        }
      
        
        let startPoint = PositionTool.nowPosition(executorEntity)
        var endPoint = CGPoint(x: 0, y: 0)
        if task.haulStage == .movingToItem {
            endPoint = PositionTool.nowPosition(targetEntity)
        }else{
            /// 具体对应的格位置
            let saveSizePoint = PositionTool.saveAreaEmptyPosition(saveArea: saveEntity)
            let savePoint = PositionTool.nowPosition(saveEntity)
            endPoint = CGPoint(x: savePoint.x + saveSizePoint.x, y: savePoint.y + saveSizePoint.y)
        }
        
       
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
        
    }
    
}

/// 中断搬运任务
extension CharacterTaskSystem {
    
    func cancelHauling(entity: RMEntity,
                       task: WorkTask) {
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("搬运物品没有了！💀💀💀")
            return
        }
        
        /// 只有从属关系改变了，才去修改回来
        if task.haulStage == .movingToTarget {
            
            /// 切除关系
            OwnerShipTool.removeOwner(owned: targetEntity, ecsManager: ecsManager)
            /// 中断任务，从属关系切换
            targetEntity.removeComponent(ofType: OwnedComponent.self)
            
            RMEventBus.shared.requestReparentEntity(entity: targetEntity, z: 10, point: PositionTool.nowPosition(entity))
       
            task.executorEntityID = 0
            task.haulStage = .movingToItem
        }
        
        task.executorEntityID = 0
        task.haulStage = .movingToItem
        
        /// 为0，说明存储区域被删除了，此任务作废
        if task.targetEntityID2 != 0 {
            /// 将任务重新放入队列
            sortTaskQueue()
        }
    
    }
}


/// 增删改查，要同时刷新任务列表
extension CharacterTaskSystem {
    
    /// 新增了存储区域实体，需要刷新对应的搬运任务
    func refreshHaulingTasksForNewSaveArea(_ saveArea: RMEntity) {
        let hauls = ecsManager.entitiesAbleToBeHaul()
        for entity in hauls {
            // 如果任务队列中已存在该实体的任务，则跳过
            guard !taskQueue.contains(where: { $0.targetEntityID == entity.entityID }) else {
                continue
            }
            addHaulingTask(entity)
        }
        
        /// 重新分配任务
        let haulTasks = taskQueue.filter{ $0.type == .Hauling }
        for task in haulTasks {
            handleHaulingTask(task)
        }
    }
    
    /// 移除了存储区域实体，需要刷新对应的搬运任务
    func refreshHaulingTasksForRemoveSaveArea(_ storageArea: RMEntity) {
        
        /// 正在搬运到此存储区的任务
        let doHaulingTasks = doTaskQueue.filter{ $0.type == .Hauling && $0.targetEntityID2 == storageArea.entityID }
        
        for task in doHaulingTasks {
            guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
                continue
            }
            
            EntityActionTool.writeLog(entity: executorEntity, text: "强制切换了任务，当前任务是：\(task.type)")
            /// 强制切换任务
            RMEventBus.shared.requestForceSwitchTask(entity: executorEntity, task: task)
        }
        
    }
    
    /// 修改了存储区域实体，需要刷新对应的搬运任务
    func refreshHaulingTasksForChangeSaveArea(_ saveArea: RMEntity) {
        isUpEvent = true
    }
    
    
    /// 生成木头
    func refreshHaulingTasksForWood(_ entity: RMEntity) {
        let task = addHaulingTask(entity)
        handleHaulingTask(task!)
    }
    
    
}
