//
//  EntityAbilityTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 用于判断实体是否具有某些能力的工具类 🚩 -
/// 用于判断实体是否具有某些能力的工具类
struct EntityAbilityTool {
    
    /// 是否可以割除
    static func ableCutting(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.cutting > 0 {
                return true
            }
        }
        return false
    }
    
    /// 是否可以搬运
    static func ableHauling(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.hauling > 0 {
                return true
            }
        }
        return false
    }
    
    /// 是否可以建造
    static func ableBuild(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.building > 0 {
                return true
            }
        }
        return false
    }
    
    /// 可以存储的实体
    static func ableToSaving(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: StorageInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 是否能执行休息任务的实体
    static func ableToRest(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: EnergyComponent.self) != nil {
            return true
        }
        return false
    }
    
    static func isRestingNow(_ entity: RMEntity) -> Bool {
        guard let restComponent = entity.getComponent(ofType: EnergyComponent.self) else {
            return false
        }
        return restComponent.isResting
    }
    
    /// 可以被砍伐的实体
    static func ableToBeCut(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: PlantBasicInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 判断实体是否可以被搬运
    static func ableToBeHaul(_ entity: RMEntity,
                             _ ecsManager: ECSManager) -> Bool {
        
        /// 搬运组件
        guard entity.getComponent(ofType: HaulableComponent.self) != nil else {
            return false
        }
        
        /// 可搬运物体，如果在非仓库的情况下，不能再次被搬运(后续在看有别的变化没)
        if let owned = entity.getComponent(ofType: OwnedComponent.self),
           let ownerEntity = ecsManager.getEntity(owned.ownedEntityID),
           ownerEntity.type != kStorageArea {
            return false
        }
        
        return true
    }
    
    /// 可以成长的植物
    static func ableToPlantGrowth(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: PlantBasicInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 可以执行任务的实体
    static func ableToTask(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: TaskQueueComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 是否可以存储当前元素
    static func ableToStorage(storage: RMEntity,material: RMEntity) -> Bool {
        
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            return false
        }
        
        return storageComponent.canStorageType[textAction(material.type)] ?? false
        
    }
    
    
    /// 蓝图，可被建造的实体
    static func ableToBeBuild(_ entity: RMEntity) -> BlueprintComponent? {
        if let component = entity.getComponent(ofType: BlueprintComponent.self) {
            return component
        }
        return nil
    }
    
    /// 种植区域，可被种植的实体
    static func ableToBeGrow(_ entity: RMEntity) -> Bool {
        guard let growComponent = entity.getComponent(ofType: GrowInfoComponent.self) else {
            return false
        }
        return true
    }
    
    /// 可执行吃饭任务
    static func ableToEat(_ entity: RMEntity) -> Bool {
        guard let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self) else {
            return false
        }
        return true
    }
    
    
    /// 素材材料等
    static func ableToBeMaterial(_ entity: RMEntity) -> CategorizationComponent? {
        if let component = entity.getComponent(ofType: CategorizationComponent.self) {
            return component
        }
        return nil
    }
    
    /// 是否可以强制替换任务
    static func ableForceSwitchTask(entity: RMEntity,
                                    task: WorkTask) -> Bool{
        
        guard entity.getComponent(ofType: WorkPriorityComponent.self) != nil else {
            return false
        }
        
        /// 没有任务，直接替换
        guard let currentTask = EntityInfoTool.currentTask(entity) else {
            return true
        }
        
        let currentType = currentTask.type
        let useCurrentType = currentTask.realType
        
        let newType = task.type
        let useNewType = task.realType
        
        /// 任务类型完全相同，不能替换
        if useCurrentType == useNewType {
            return false
        }
        
        /// 当前任务等级
        let currentTaskLevel = EntityInfoTool.workPriority(entity: entity, workType: useCurrentType)
        /// 新任务等级
        let newTaskLevel = EntityInfoTool.workPriority(entity: entity, workType: useNewType)
        
        /// 当前任务级别更高，不能强转任务
        if currentTaskLevel < newTaskLevel {
            return false
        }else if currentTaskLevel > newTaskLevel {
            /// 当前任务级别低，能强转任务
            return true
        }else {
            /// 相等的情况
            /// 玩家设置的优先级相等，比较从左至右优先级，返回优先级高的
            let type = EntityActionTool.compareTaskPriority(type1: useNewType, type2: useCurrentType)
            
            /// 如果返回的是新任务，那么新任务优先级高，可以强转
            if type == task.type {
                return true
            }else{
                return false
            }
        }
        
    }
    
    /// 是否可以点击
    static func ableToClick(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: NonInteractiveComponent.self ) != nil {
            return false
        }
        
        return true
    }
    
    /// 是否被标记了可以砍伐
    static func ableToMarkCut(_ entity: RMEntity,
                              _ ecsManager: ECSManager) -> Bool {
        
        if EntityInfoTool.getAX(targetEntity: entity, ecsManager: ecsManager) != nil {
            return true
        }
        
        return false
    }
    
    /// 是否被标记了可以采矿
    static func ableToMarkMine(_ entity: RMEntity,
                              _ ecsManager: ECSManager) -> Bool {
        
        if EntityInfoTool.getMine(targetEntity: entity, ecsManager: ecsManager) != nil {
            return true
        }
        
        return false
    }
    
    
    /// 是否被标记了可以砍伐
    static func ableToMarkPick(_ entity: RMEntity,
                               _ ecsManager: ECSManager) -> Bool {
        
        if EntityInfoTool.getHand(targetEntity: entity, ecsManager: ecsManager) != nil {
            return true
        }
        
        return false
    }
    
    /// 是否可以生成砍伐任务
    static func ableToAddTask(entity: RMEntity, ecsManager: ECSManager) -> Bool{
        
        guard let taskSystem = ecsManager.systemManager.getSystem(ofType: TaskSystem.self) else {
            return false
        }
        
        
        let doTaskQueue = taskSystem.doTaskQueue
        let allTaskQueue = taskSystem.allTaskQueue
        
        /// 正在做的任务有此目标
        if doTaskQueue.firstIndex(where: {
            $0.targetEntityID == entity.entityID
        }) != nil{
            return false
        }
        
        /// 总任务列表里有此目标
        if allTaskQueue.firstIndex(where: { $0.targetEntityID == entity.entityID
        }) != nil{
            return false
        }
        
        return true
    }
    
    
    /// 删除时，是否会撒下子类数据
    func removeAbleToLastSubEntity() {
        
    }
  
 
}
