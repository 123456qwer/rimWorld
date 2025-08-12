//
//  ECS+TaskSystem.swift
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
        
        systemManager.getSystem(ofType: TaskSystem.self)?.addRestTask(entity, mustRest)
    }
    
    /// 添加搬运任务
    func addHaulingTask(_ entity: RMEntity){
        systemManager.getSystem(ofType: TaskSystem.self)?.addHaulingTask(entity)
    }
    
    /// 添加采矿任务
    func addOrCancelMiningTask (_ entity: RMEntity,
                                _ canMine: Bool) {
        /// UI显示是否有镐子
        mineStatusChange(entity, canMine: canMine)
        systemManager.getSystem(ofType: TaskSystem.self)?.addOrCancelMiningTask(entity, canMine)
    }
    
    /// 添加砍伐任务
    func addOrCancelCuttingTask (_ entity: RMEntity,
                                 _ canChop: Bool) {
        /// UI显示是否有斧头
        chopStatusChange(entity,canChop: canChop)
        systemManager.getSystem(ofType: TaskSystem.self)?.addOrCancelCuttingTask(entity, canChop)
    }
    
    /// 添加采摘任务
    func addOrCancelPickingTask (_ entity: RMEntity,
                                 _ canPick: Bool) {
        /// UI显示是否有手
        pickStatusChange(entity,canPick: canPick)
        systemManager.getSystem(ofType: TaskSystem.self)?.addOrCancelPickingTask(entity, canPick)
    }
    
    
    
    /// 添加建造任务
    func addBuildTask (_ entity: RMEntity) {
        systemManager.getSystem(ofType: TaskSystem.self)?.addBuildTask(entity)
    }
    

    /// 添加睡觉任务
    func addSleepTask (_ entity: RMEntity) {
        systemManager.getSystem(ofType: TaskSystem.self)?.addSleepTask(entity)
    }
 
  
    
    /// 执行任务
    func doTask(entityID: Int, task: WorkTask) {
        systemManager.getSystem(ofType: TaskSystem.self)?.doTask(entityID: entityID, task: task)
    }
    
    /// 完成任务
    func completeTask(entityID: Int,
                      task: WorkTask) {
        systemManager.getSystem(ofType: TaskSystem.self)?.completeTask(entityID: entityID, task: task)
    }
    
    /// 强制转换任务
    func TaskSystemForceSwitchTask(entity: RMEntity,
                                            task: WorkTask){
        systemManager.getSystem(ofType: TaskSystem.self)?.forceSwitchTask(entity: entity, task: task)
    }
    
    /// 修改任务优先级
    func updatePriorityEntity(entity: RMEntity,
                              workType: WorkType) {
        systemManager.getSystem(ofType: TaskSystem.self)?.updatePriorityEntity(entity: entity, workType: workType)
    }
    
    /// 修改存储实体
    func changeSaveAreaEntity(_ entity: RMEntity) {
        systemManager.getSystem(ofType:TaskSystem.self)?.refreshHaulingTasksForChangeSaveArea(entity)
    }
    
    
    /// 任务系统新增实体
    func characterTaskAdd(entity: RMEntity) {
        
        systemManager.getSystem(ofType: TaskSystem.self)?.addForRefreshTasks(entity: entity)
    }
    
    /// 任务系统删除实体
    func characterTaskRemove(entity: RMEntity) {
        
        systemManager.getSystem(ofType: TaskSystem.self)?.removeForRefreshTasks(entity: entity)
    }
    
    /// 重置此类型的搬运任务
    func reloadHaulingTasks(materialType: MaterialType) {
        systemManager.getSystem(ofType: TaskSystem.self)?.reloadHaulTaskWithMaterial(material: materialType)
    }
    
    
    /// 完成一个搬运任务后，刷新一下蓝图任务
    func refreshBlueprint(entity: RMEntity) {
        
    }
    
    /// 蓝图状态更新，看是否需要去建造
    func updateBlueprint(entity: RMEntity) {
        
    }
    
}
