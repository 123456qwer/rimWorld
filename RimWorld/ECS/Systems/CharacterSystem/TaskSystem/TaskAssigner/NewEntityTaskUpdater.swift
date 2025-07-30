//
//  NewEntityTaskUpdater.swift
//  RimWorld
//
//  Created by wu on 2025/7/30.
//

import Foundation

/// 新增实体，处理任务逻辑
extension CharacterTaskSystem {
    
    /// 新增实体
    func addForRefreshTasks(entity: RMEntity){
        
        let type = entity.type
        
        switch type {
            /// 搬运任务
        case kWood:
            /// 新增木头、
            addHaulingTasks(targetEntity: entity)
        case kStorageArea:
            /// 新增存储空间
            addStorage(targetEntity: entity)
        case kBlueprint:
            /// 新增蓝图实体
            addBlueprint(targetEntity: entity)
            
        default:
            break
        }
    }
    
    
    /// 新增仓库实体
    func addStorage(targetEntity: RMEntity) {
        /// 所有可搬运实体
        let ableToBeHaul = ecsManager.entitiesAbleToBeHaul()
        
        for entity in ableToBeHaul {
            guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else { continue }
            /// 正在做的任务有此目标
            if doTaskQueue.firstIndex(where: {
                $0.targetEntityID == entity.entityID
            }) != nil{ continue }
            
            /// 总任务列表里有此目标
            if allTaskQueue.firstIndex(where: { $0.targetEntityID == entity.entityID
            }) != nil{ continue }
            
            /// 生成实体搬运任务
            ableToStorageForHaulingTask(storageE: targetEntity, targetEntity: entity, haulComponent: haulComponent)
        }
        
   
        
        assignTask()

    }
    
    
    /// 新增蓝图实体
    func addBlueprint(targetEntity: RMEntity) {
        
        /// 所有可搬运实体
        let ableToBeHaul = ecsManager.entitiesAbleToBeHaul()
       
        for entity in ableToBeHaul {
            guard entity.getComponent(ofType: HaulableComponent.self) != nil else { continue }
            
            let targetMaterialType = EntityInfoTool.materialType(entity)
            if targetMaterialType == .unowned { continue }
            
           
            /// 正在做的任务有此目标
            if doTaskQueue.firstIndex(where: {
                $0.targetEntityID == entity.entityID
            }) != nil{ continue }
            
            /// 总任务列表里有此目标
            if allTaskQueue.firstIndex(where: { $0.targetEntityID == entity.entityID
            }) != nil{ continue }
            
            /// 直接add，别在这里创建，这里没有排序优先级，蓝图的话
            addHaulingTasks(targetEntity: entity)
//            /// 生成蓝图搬运任务
//            let isCreate = ableToBlueprintForHaulingTask(blueE: targetEntity, targetMaterialType: targetMaterialType, targetEntity: entity)
         
        }
        
        
        assignTask()
    }
    
    
    /// 新增可搬运实体
    func addHaulingTasks(targetEntity: RMEntity){
        
        /// 未有搬运人
        let ableToHaul = ecsManager.entitiesAbleToHaul()
        if ableToHaul.count == 0 {
            return
        }
        
        /// 搬运原料
        let targetMaterialType = EntityInfoTool.materialType(targetEntity)
        if targetMaterialType == .unowned {
            ECSLogger.log("原材料未知！！💀💀💀")
            return
        }
        
        
        /// 搬运组件
        guard let haulComponent = targetEntity.getComponent(ofType: HaulableComponent.self) else { return }
        
        /// 正在做的任务有此目标
        if doTaskQueue.firstIndex(where: {
            $0.targetEntityID == targetEntity.entityID
        }) != nil{
            return
        }
        
        /// 总任务列表里有此目标
        if allTaskQueue.firstIndex(where: { $0.targetEntityID == targetEntity.entityID
        }) != nil{
            return
        }
        
        
        /// 可执行建造命令的实体
        let ableToBuild = ecsManager.entitiesAbleToBuild()
        /// 蓝图实体
        let ableToBeBuild = ecsManager.entitiesAbleToBeBuild()
        /// 存储实体
        var ableToStorage = ecsManager.entitiesAbleToStorage()
        
      
        
        /// 搬运目标为蓝图实体
        if ableToBuild.count != 0 && ableToBeBuild.count != 0 {
            
            var beBuilds:[RMEntity] = []
            for (_ , blueprintEntity) in ableToBeBuild {
                beBuilds.append(blueprintEntity)
            }
            
            /// 按距离由近到远排序
            beBuilds = PositionTool.sortEntityForDistance(entity: targetEntity, entities: beBuilds)
            /// 按需求排序，需求量最小的优先，避免一个都造不完
            beBuilds = PositionTool.sortBlueprintEntitiesByNeed(targetEntity: targetEntity, blueprintEntities: beBuilds)
       
            /// 蓝图
            for blueE in beBuilds {
                
                let canCreateTask = ableToBlueprintForHaulingTask(blueE: blueE, targetMaterialType: targetMaterialType, targetEntity: targetEntity)
                if canCreateTask {
                    return
                }
               
            }
            
        }
        
        
        /// 搬运目标位为储实体
        if ableToStorage.count != 0 {
            
            /// 按距离由近到远排序
            ableToStorage = PositionTool.sortEntityForDistance(entity: targetEntity, entities: ableToStorage)
            

            /// 存储仓库
            for storageE in ableToStorage {
                
                
               let canCreateTask = ableToStorageForHaulingTask(storageE: storageE,
                                            targetEntity: targetEntity,
                                            haulComponent: haulComponent)
                if canCreateTask {
                    return
                }
            }
            
            
        }
        
    }
    
    
}
