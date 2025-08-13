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
    
    func entitiesAbleToBuild() -> [RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBuild ?? []
    }
    
    /// 获取所有可被砍伐的实体
    func entitiesAbleToBeCut() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBeCut ?? []
    }
    
    /// 获取所有可被吃的实体
    func entitiesAbleToBeEat() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBeEat ?? []
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
    
    /// 所有种植区域
    func entitiesAbleToBeGrowArea() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToBeGrowArea ?? []
    }
    
    /// 可以执行吃命令的实体
    func entitiesAbleToEat() -> Set<RMEntity> {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesAbleToEat ?? []
    }
    
    /// 所有可以被建造的蓝图实体
    func entitiesAbleToBeBuild() -> [TilePoint:RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesBlueprint ?? [:]
    }
    
    /// 所有素材实体
    func entitiesAbleToMaterial(key: MaterialType) -> Set<RMEntity>? {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.entitiesMaterial[key] ?? []
    }
    
    /// 将此实体从搬运列表中删除
    func removeHaulEntity(entity: RMEntity) {
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.removeHaulEntity(entity: entity)
    }
    
    /// 正在休息的实体
    func isRestingEntities() -> [Int: RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.restEntities ?? [:]
    }
    
    /// 没休息的实体
    func unRestingEntities() -> [Int: RMEntity] {
        return systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.unRestEntities ?? [:]
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
    
    /// 修改休息状态
    func restStatusAction(entity: RMEntity, isRest: Bool){
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.restStatusAction(entity: entity, isRest: isRest)
    }
    
}
