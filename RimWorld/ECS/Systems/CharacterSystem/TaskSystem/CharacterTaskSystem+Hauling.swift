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
            addHaulingTasks(targetEntity: entity)
        }
    }
    
    // 初始化时分配搬运任务
    func assignInitialHaulingTasks() {
      
    }
    
    /// 添加搬运任务
    @discardableResult
    func addHaulingTask(_ entity: RMEntity) -> WorkTask? {
    
        
        let task = WorkTask(type: .Hauling,
                            targetEntityID: entity.entityID,
                            executorEntityID: 0)
        task.haulingTask.haulStage = .movingToItem
        allTaskQueue.append(task)
        
        return task
    }
    

    /// 处理搬运任务
    func handleHaulingTask(executorEntity: RMEntity,
                           task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
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
        guard ecsManager.getEntity(task.haulingTask.targetId) != nil else {
            ECSLogger.log("搬运目的地为空！💀💀💀")
            
            RMEventBus.shared.requestForceCancelTask(entity: executorEntity, task: task)
            EntityActionTool.removeTask(entity: executorEntity, task: task)

            return
        }
      
        
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = provider.pointFromScene(targetEntity)
        
       
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
        if task.haulingTask.haulStage == .movingToTarget {
            
            /// 切除关系
            OwnerShipTool.removeOwner(owned: targetEntity, ecsManager: ecsManager)
            /// 中断任务，从属关系切换
            targetEntity.removeComponent(ofType: OwnedComponent.self)
            
            RMEventBus.shared.requestReparentEntity(entity: targetEntity, z: 10, point: PositionTool.nowPosition(entity))
       
            task.executorEntityID = 0
            task.haulingTask.haulStage = .movingToItem
        }
        
        
        /// 蓝图，需要取消对应的
        if let blueEntity = ecsManager.getEntity(task.haulingTask.targetId) {
            if let blueComponent = blueEntity.getComponent(ofType: BlueprintComponent.self) {
                
                /// 设置为0
                let materialType = EntityInfoTool.materialType(targetEntity)
                
                blueComponent.alreadyCreateHaulTask[materialType]?[targetEntity.entityID] = 0
            }
        }
        
        /// 任务作废
        removeDoTask(task: task)
        
        /// 生成新任务
        addHaulingTasks(targetEntity: targetEntity)
    }
}


/// 增删改查，要同时刷新任务列表
extension CharacterTaskSystem {
    
   
    
    /// 修改了存储区域实体，需要刷新对应的搬运任务
    func refreshHaulingTasksForChangeSaveArea(_ storageArea: RMEntity) {
        refreshHaulTasks()
    }
    
    /// 移除了存储区域实体，需要刷新对应的搬运任务
    func refreshHaulingTasksForRemoveSaveArea(_ storageArea: RMEntity) {
        refreshHaulTasks()
    }
    
    /// 新增了蓝图，需要刷新对应的搬运任务
    func refreshHaulingTasksForNewBlueprint(_ blueprint: RMEntity) {
        refreshHaulTasks()
    }
    
    func refreshHaulTasks() {
        let beHaulEntities = ecsManager.entitiesAbleToBeHaul()
        for entity in beHaulEntities {
            addHaulingTasks(targetEntity: entity)
        }
        assignTask()
    }
 
    
  
    
    
}
