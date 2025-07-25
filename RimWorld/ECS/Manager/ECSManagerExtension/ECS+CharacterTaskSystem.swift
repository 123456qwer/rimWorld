//
//  ECS+CharacterTaskSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 任务系统
extension ECSManager {
    
    /// 添加休息任务
    func addRestTask(_ entity: RMEntity,
                     _ mustRest:Bool){
        
        let task = systemManager.getSystem(ofType: CharacterTaskSystem.self)?.addRestTask(entity, mustRest)
        if let task = task {
            handleRestTask(task, mustRest)
        }
    }
    
    /// 添加搬运任务
    func addHaulingTask(_ entity: RMEntity){
        
        let task = systemManager.getSystem(ofType: CharacterTaskSystem.self)?.addHaulingTask(entity)
        if let task = task {
            /// 执行搬运任务
            handleHaulingTask(task)
        }
        
    }
    
    /// 添加砍伐任务
    func addOrCancelCuttingTask (_ entity: RMEntity,
                                 _ canChop: Bool) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.addOrCancelCuttingTask(entity, canChop)
        /// UI显示是否有斧头
        self.treeStatusChange(entity,canChop: canChop)
        
        if canChop {
            handleCuttingTask()
        }
    }
    
    /// 添加建造任务
    func addBuildTask (_ entity: RMEntity){
        let task = systemManager.getSystem(ofType: CharacterTaskSystem.self)?.addBuildTask(entity)
        if let task = task {
            handleBuildTask(task)
        }
    }
    
    /// 处理休息任务
    func handleRestTask(_ task: WorkTask,_ mustRest:Bool) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.handleRestTask(task, mustRest)
    }
    
    /// 处理建造任务
    func handleBuildTask(_ task: WorkTask) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.handleBuildTask(task)
    }
    
    /// 处理砍伐任务
    func handleCuttingTask() {
        systemManager.getSystem(ofType:CharacterTaskSystem.self)?.handleCuttingTask()
    }
    
    /// 处理搬运任务
    func handleHaulingTask(_ task: WorkTask) {
        systemManager.getSystem(ofType:CharacterTaskSystem.self)?.handleHaulingTask(task)
    }
    
  
    
    /// 执行任务
    func doTask(entityID: Int, task: WorkTask) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.doTask(entityID: entityID, task: task)
    }
    
    /// 完成任务
    func completeTask(entityID: Int,
                      task: WorkTask) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.completeTask(entityID: entityID, task: task)
    }
    
    /// 强制转换任务
    func characterTaskSystemForceSwitchTask(entity: RMEntity,
                                            task: WorkTask){
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.forceSwitchTask(entity: entity, task: task)
    }
    
    /// 修改任务优先级
    func updatePriorityEntity(entity: RMEntity,
                              workType: WorkType) {
        systemManager.getSystem(ofType: CharacterTaskSystem.self)?.updatePriorityEntity(entity: entity, workType: workType)
    }
    
    /// 修改存储实体
    func changeSaveAreaEntity(_ entity: RMEntity) {
        systemManager.getSystem(ofType:CharacterTaskSystem.self)?.refreshHaulingTasksForChangeSaveArea(entity)
    }
    
    
    /// 任务系统新增实体
    func characterTaskAdd(entity: RMEntity) {
        
        /// 新增存储区域
        if entity.type == kStorageArea {
            systemManager.getSystem(ofType:CharacterTaskSystem.self)?.refreshHaulingTasksForNewSaveArea(entity)
        }else if entity.type == kBlueprint {
            /// 新增蓝图
            systemManager.getSystem(ofType: CharacterTaskSystem.self)?.refreshBuildTask(entity)
        }else if entity.type == kWood {
            /// 新增搬运任务
            systemManager.getSystem(ofType: CharacterTaskSystem.self)?.refreshHaulingTasksForWood(entity)
        }
    }
    
    /// 任务系统删除实体
    func characterTaskRemove(entity: RMEntity) {
        
        /// 移除存储区域
        if entity.type == kStorageArea {
            systemManager.getSystem(ofType:CharacterTaskSystem.self)?.refreshHaulingTasksForRemoveSaveArea(entity)
        }
    }
    
    
    /// 蓝图状态更新，看是否需要去建造
    func updateBlueprint(entity: RMEntity) {
        
    }
    
}
