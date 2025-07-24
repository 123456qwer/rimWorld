//
//  ECS+EntityCategorizatonSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 类型分类系统
extension ECSManager {
    
    /// 生长完毕，移除任务
    func removeGrowthEntity(_ entity: RMEntity) {
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.removeGrowthEntity(entity)
    }
    
    /// 修改优先级后，重置任务分类
    func reloadEntityCategorization(workType: WorkType,
                                    entity: RMEntity) {
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.reloadCategorization(workType: workType,entity: entity)
    }
    
    /// 获取所有可以砍树的实体
    func entitiesAbleToCut() -> [RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToCut ?? []
    }
    
    /// 获取所有可被砍伐的实体
    func entitiesAbleToBeCut() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBeCut ?? []
    }
    
    /// 获取所有可以执行搬运任务的实体
    func entitiesAbleToHaul() -> [RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToHaul ?? []
    }
    
    /// 获取所有可以执行任务的实体
    func entitiesAbleToTask() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToTask ?? []
    }
    
    /// 获取所有可以被搬运的实体
    func entitiesAbleToBeHaul() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBeHaul ?? []
    }
    
    /// 获取所有可以执行休息任务的实体
    func entitiesAbleToRest() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToRest ?? []
    }
    
    /// 获取所有存储区域的实体
    func entitiesAbleToStorage() -> [RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToStorage ?? []
    }

    /// 所有可以成长的植物
    func entitiesAbleToPlantGrowth() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToPlantGrowth ?? []
    }
    
    /// 所有可以被建造的实体
    func entitiesAbleToBeBuild() -> [TilePoint:RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesBlueprint ?? [:]
    }
    
    /// 添加实体，分区需要刷新
    func categorizationAdd(entity: RMEntity) {
        /// 分类系统，新加存储区域
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.addEntity(entity)
    }
    
    /// 删除实体，分区需要刷新
    func categorizationRemove(entity: RMEntity) {
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.removeEntity(entity)
    }
}
