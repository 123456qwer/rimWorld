//
//  EntityCategorizatonSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/4.
//

import Foundation


/// 分类系统
class EntityCategorizatonSystem: System {
    
    let ecsManger:ECSManager
    
    
    // MARK: - 可执行任务的实体 -
    
    /// 可以执行砍伐任务的实体
    var entitiesAbleToCut: [RMEntity] = []
    /// 可以执行搬运任务的实体
    var entitiesAbleToHaul: [RMEntity] = []
    /// 可执行存储任务的实体
    var entitiesAbleToStorage: [RMEntity] = []
    /// 可执行建造任务的实体
    var entitiesAbleToBuild: [RMEntity] = []
    
    
    /// 可执行休息任务的实体
    var entitiesAbleToRest: Set<RMEntity> = []
    /// 可执行吃饭任务的实体
    var entitiesAbleToEat: Set<RMEntity> = []
    /// 所有可以执行任务的实体
    var entitiesAbleToTask: Set<RMEntity> = []
    
    // MARK: - 被执行的实体 -
    
    /// 可以被砍伐的实体
    var entitiesAbleToBeCut: Set<RMEntity> = []
    /// 可以被搬运的实体
    var entitiesAbleToBeHaul: Set<RMEntity> = []
    /// 可以被种植的实体<种植区域>
    var entitiesAbleToBeGrowArea: Set<RMEntity> = []
    /// 可以被吃的实体<也叫食物...>
    var entitiesAbleToBeEat: Set<RMEntity> = []
    
    // MARK: - 可以生长的植物实体 -
    var entitiesAbleToPlantGrowth: Set<RMEntity> = []
    
    
    
    // MARK: - 建筑蓝图 -
    var entitiesBlueprint: [TilePoint:RMEntity] = [:]
    
    
    // MARK: - 建造素材等 -
    var entitiesMaterial: [MaterialType:Set<RMEntity>] = [:]
    
    /// 移除的时候统一从这里处理
    private var setEntities:[Set<RMEntity>] = []
    private var arrEntities:[[RMEntity]] = []
    
    
    /// 休息中的角色
    var restEntities:[Int : RMEntity] = [:]
    /// 非休息中的橘色
    var unRestEntities:[Int: RMEntity] = [:]
    
    
    init(ecsManger: ECSManager) {
        self.ecsManger = ecsManger
        var arr  = [entitiesAbleToCut,
                    entitiesAbleToHaul,
                    entitiesAbleToStorage,
                    entitiesAbleToBuild,]
        var sets = [entitiesAbleToRest,
                    entitiesAbleToEat,
                    entitiesAbleToTask,
                    entitiesAbleToBeCut,
                    entitiesAbleToBeHaul,
                    entitiesAbleToBeGrowArea,
                    entitiesAbleToBeEat,
                    entitiesAbleToPlantGrowth]
        for entities in sets {
            setEntities.append(entities)
        }
        for entities in arr {
            arrEntities.append(entities)
        }
    }
    
    /// 排序
    func sortEntities() {
        /// 由低到高排序 (级别越高，优先级越高)
        entitiesAbleToCut.sort { PriorityTool.cuttingPriority($0)  < PriorityTool.cuttingPriority($1) }
        entitiesAbleToHaul.sort { PriorityTool.haulingPriority($0) < PriorityTool.haulingPriority($1) }
        entitiesAbleToStorage.sort { PriorityTool.storagePriority($0) > PriorityTool.storagePriority($1)}
        entitiesAbleToBuild.sort{ PriorityTool.buildPriority($0) > PriorityTool.buildPriority($1)}
    }
    
    
    /// 添加实体
    func addEntity(_ entity: RMEntity) {
        categorization(entity)
        sortEntities()
    }
    
    /// 删除实体
    func removeEntity(_ entity: RMEntity) {
        
        /// 从arr数组中删除
        for i in arrEntities.indices {
            var entities = arrEntities[i]
            if let index = entities.firstIndex(where: { $0 === entity}){
                entities.remove(at: index)
            }
        }
        
        /// 从set数组中删除
        for i in setEntities.indices {
            setEntities[i].remove(entity)
        }
        
   
        restEntities.removeValue(forKey: entity.entityID)
        unRestEntities.removeValue(forKey: entity.entityID)
        
        /// 删除建筑蓝图
        if let component = EntityAbilityTool.ableToBeBuild(entity) {
            entitiesBlueprint.removeValue(forKey: component.key)
        }
        
        /// 删除素材
        if let component = EntityAbilityTool.ableToBeMaterial(entity) {
            if let key = MaterialType(rawValue: component.categorization) {
                var set: Set<RMEntity> = entitiesMaterial[key] ?? []
                set.remove(entity)
            }
        }
        
        sortEntities()
    }
    
    
    func categorize() {
        let entities = ecsManger.allEntities()
        for entity in entities {
            categorization(entity)
        }
        
        sortEntities()
    }
    
    /// 重置分类（根据工作类型和优先级动态增删可用实体）
    func reloadCategorization(workType: WorkType, entity: RMEntity) {
        
        let priority = EntityInfoTool.workPriority(entity: entity, workType: workType)
        
        switch workType {
        case .Cutting:
            updateEntityList(&entitiesAbleToCut, entity: entity, isEligible: priority > 0)
            
        case .Hauling:
            updateEntityList(&entitiesAbleToHaul, entity: entity, isEligible: priority > 0)
            
        case .Rest:
            updateEntitySet(&entitiesAbleToRest, entity: entity, isEligible: priority > 0)
            

        default:
            break // 其他类型暂不处理
        }
    }
    
    
    /// 移除可搬运物
    func removeHaulEntity(entity: RMEntity){
        entitiesAbleToBeHaul.remove(entity)
    }

    
    private func updateEntityList(_ list: inout [RMEntity], entity: RMEntity, isEligible: Bool) {
        if isEligible {
            if !list.contains(where: { $0.entityID == entity.entityID }) {
                list.append(entity)
            }
        } else {
            list.removeAll(where: { $0.entityID == entity.entityID })
        }
    }
    
    private func updateEntitySet(_ set: inout Set<RMEntity>, entity: RMEntity, isEligible: Bool) {
        if isEligible {
            set.insert(entity)
        } else {
            set.remove(entity)
        }
    }
    
    /// 分类
    func categorization(_ entity: RMEntity) {
        
        if EntityAbilityTool.ableToRest(entity) {
            entitiesAbleToRest.insert(entity)
            
            if EntityAbilityTool.isRestingNow(entity) {
                restEntities[entity.entityID] = entity
            }else {
                unRestEntities[entity.entityID] = entity
            }
        }
        
        
        if EntityAbilityTool.ableBuild(entity) {
            entitiesAbleToBuild.append(entity)
        }
        
        if EntityAbilityTool.ableCutting(entity) {
            entitiesAbleToCut.append(entity)
        }
        
        if EntityAbilityTool.ableHauling(entity) {
            entitiesAbleToHaul.append(entity)
        }
        
        if EntityAbilityTool.ableToSaving(entity) {
            entitiesAbleToStorage.append(entity)
        }
        
        if EntityAbilityTool.ableToBeCut(entity) {
            entitiesAbleToBeCut.insert(entity)
        }
        
        if EntityAbilityTool.ableToBeHaul(entity,ecsManger) {
            entitiesAbleToBeHaul.insert(entity)
        }
        
        if EntityAbilityTool.ableToTask(entity) {
            entitiesAbleToTask.insert(entity)
        }
        
        if EntityAbilityTool.ableToPlantGrowth(entity) {
            entitiesAbleToPlantGrowth.insert(entity)
        }
        
        if EntityAbilityTool.ableToBeGrow(entity) {
            entitiesAbleToBeGrowArea.insert(entity)
        }
        
        if EntityAbilityTool.ableToEat(entity) {
            entitiesAbleToEat.insert(entity)
        }
        
        
        if EntityAbilityTool.ableToBeEat(entity) {
            entitiesAbleToBeEat.insert(entity)
        }
        

        if let component = EntityAbilityTool.ableToBeBuild(entity) {
            entitiesBlueprint[component.key] = entity
        }
        
       
        if let component = EntityAbilityTool.ableToBeMaterial(entity) {
            if let key = MaterialType(rawValue: component.categorization) {
                var set: Set<RMEntity> = entitiesMaterial[key] ?? []
                set.insert(entity)
                entitiesMaterial[key] = set
            }
        }
    }
    
    /// 移除可生长的植物
    func removeGrowthEntity(_ entity: RMEntity) {
        entitiesAbleToPlantGrowth.remove(entity)
    }
    
    /// 修改休息状态
    func restStatusAction(entity: RMEntity,
                          isRest: Bool){
        if isRest {
            unRestEntities.removeValue(forKey: entity.entityID)
            restEntities[entity.entityID] = entity
        }else {
            restEntities.removeValue(forKey: entity.entityID)
            unRestEntities[entity.entityID] = entity
        }
    }
}
