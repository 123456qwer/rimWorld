//
//  EntityInfoTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 EntityInfo 工具类 🚩 -
/// 实体常用属性工具类
struct EntityInfoTool {
    
    /// 当前正在执行的任务
    static func currentTask(_ entity: RMEntity) -> WorkTask? {
        if let taskComponent = entity.getComponent(ofType: TaskQueueComponent.self) {
            if taskComponent.tasks.count > 0 {
                return taskComponent.tasks.first!
            }
        }
        
        return nil
    }
    
    /// 当前实体原料
    static func materialType(_ entity: RMEntity) -> MaterialType {
        
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return MaterialType.unowned
        }
        
        return MaterialType(rawValue: haulComponent.materialType) ?? MaterialType.unowned
    }
    
    /// 当前可以承担的重量
    static func remainingCarryCapacity(_ entity: RMEntity) -> Double {
        guard let carryComponent = entity.getComponent(ofType: CarryingCapacityComponent.self) else {
            return 0
        }
        return carryComponent.maxCapacity - carryComponent.currentLoad
    }
  
    /// 当前可搬运物的重量
    static func haulingWeight(_ entity:RMEntity) -> Double {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return 0
        }
      
        return Double(Int(haulComponent.weight * 100)) / 100.0  // 0.6
    }
    
    /// 当前可搬运物的数量
    static func haulingCount(_ entity: RMEntity) -> Int {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return 0
        }
        return haulComponent.currentCount
    }
    
    /// 是否在仓库
    static func isInStorage(entity: RMEntity, ecsManager: ECSManager) -> Bool{
        guard let ownedComponent = entity.getComponent(ofType: OwnedComponent.self) else {
            return false
        }
        
        var isInStorage = false
        
        let storage = ecsManager.getEntity(ownedComponent.ownedEntityID)
        if (storage != nil) && storage?.type == kStorageArea {
            isInStorage = true
        }
        
        return isInStorage
    }
    
    /// 仓库最大载容量
    static func maxStorageCapacity(storage: RMEntity) -> Int{
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            return 0
        }
        
        let size = storageComponent.size
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        /// 存储区域总格子数
        let totalTiles = abs(cols * rows)
        /// 当前格子上存储的实体
        let storageEntities = storageComponent.saveEntities
        
        let lastStorageArea = totalTiles - storageEntities.count
        
        return lastStorageArea * 75
    }
    
    
    /// 蓝图需要的数量
    static func blueprintNeedCount(_ entity: RMEntity,
                                   _ material: Int) -> Int {
        
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return 0
        }
        /// 需要的原材料
        for (materialType,valueCount) in blueComponent.alreadyMaterials {
            /// 说明这个蓝图缺此材料
            if Int(materialType) == material {
                let maxCount = blueComponent.materials[materialType] ?? 0
                return maxCount - valueCount
            }
        }
        
        return 0
    }
    
    /// 蓝图所需素材是否完毕
    static func blueprintIsComplete(_ entity: RMEntity) {
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        let maxMaterials = blueComponent.materials
        let alreadyMaterials = blueComponent.alreadyMaterials
        
        var isComplete = true
        for (key,count) in alreadyMaterials {
            let maxCount = maxMaterials[key]!
            if maxCount != count {
                isComplete = false
            }
        }
        blueComponent.isMaterialCompelte = isComplete
    }
    
    /// 获取所有可做的任务
    static func allCanDoTask(_ entity: RMEntity) -> [WorkType] {
        guard let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) else {
            return []
        }

        // 映射所有任务及其优先级
        let priorityMap: [(WorkType, Int)] = [
            (.Firefighting, workComponent.firefighting),
            (.SelfCare, workComponent.selfCare),
            (.Doctor, workComponent.doctor),
            (.Rest, workComponent.rest),
            (.Basic, workComponent.basic),
            (.Supervise, workComponent.supervise),
            (.AnimalHandling, workComponent.animalHandling),
            (.Cooking, workComponent.cooking),
            (.Hunting, workComponent.hunting),
            (.Building, workComponent.building),
            (.Growing, workComponent.growing),
            (.Mining, workComponent.mining),
            (.Cutting, workComponent.cutting),
            (.Smithing, workComponent.smithing),
            (.Tailoring, workComponent.tailoring),
            (.Art, workComponent.art),
            (.Crafting, workComponent.crafting),
            (.Hauling, workComponent.hauling),
            (.Cleaning, workComponent.cleaning),
            (.Research, workComponent.research)
        ]

        // 过滤掉不能做的（优先级 <= 0），然后按优先级升序排列
        return priorityMap
            .filter { $0.1 > 0 }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
    }
    
    /// 获取此状态的优先级
    static func workPriority(entity: RMEntity?,
                             workType: WorkType) -> Int{
        
        guard let entity = entity else {
            return 3
        }
        
        guard let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) else {
            return 0
        }
        
        switch workType {
        case .Firefighting:
            return workComponent.firefighting
        case .SelfCare:
            return workComponent.selfCare
        case .Doctor:
            return workComponent.doctor
        case .Rest:
            return workComponent.rest
        case .Basic:
            return workComponent.basic
        case .Supervise:
            return workComponent.supervise
        case .AnimalHandling:
            return workComponent.animalHandling
        case .Cooking:
            return workComponent.cooking
        case .Hunting:
            return workComponent.hunting
        case .Building:
            return workComponent.building
        case .Growing:
            return workComponent.growing
        case .Mining:
            return workComponent.mining
        case .Cutting:
            return workComponent.cutting
        case .Smithing:
            return workComponent.smithing
        case .Tailoring:
            return workComponent.tailoring
        case .Art:
            return workComponent.art
        case .Crafting:
            return workComponent.crafting
        case .Hauling:
            return workComponent.hauling
        case .Cleaning:
            return workComponent.cleaning
        case .Research:
            return workComponent.research
        case .None:
            return 0
        }
    }
    
    /// 可收货量
    static func currentHarvestAmountForPlant(entity: RMEntity) -> Int {
        guard let plantComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            return 0
        }
        let yield = Float(plantComponent.harvestYield) * plantComponent.growthPercent
        return max(1, Int(yield.rounded(.down)))
    }
    
    /// 可收货量
    static func currentHarvestAmountForMine(entity: RMEntity) -> Int {
        guard let mineComponent = entity.getComponent(ofType: MiningComponent.self) else {
            return 0
        }
        let yield = Float(mineComponent.harvestYield)
        return max(1, Int(yield.rounded(.down)))
    }
    
    
    /// 获取种植区域的所有keys
    static func getGrowingAllKeys (targetEntity: RMEntity) -> [Int] {
        guard let areaComponent = targetEntity.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("此种植区域没有基础存储控件！💀💀💀")
            return []
        }
        
        let size = areaComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        var keys:[Int] = []
        for index in 0..<totalTiles {
            keys.append(index)
        }
        
        return keys
    }
    
    /// 获取斧子
    static func getAX (targetEntity: RMEntity, ecsManager: ECSManager) -> RMEntity? {
        guard let ownerComponent = targetEntity.getComponent(ofType: OwnershipComponent.self) else { return nil }
        
        for entityID in ownerComponent.ownedEntityIDS {
            if let entity = ecsManager.getEntity(entityID), entity.type == kAX  {
                return entity
            }
        }
        
        return nil
    }
    
    /// 获取矿稿
    static func getMine (targetEntity: RMEntity, ecsManager: ECSManager) -> RMEntity? {
        guard let ownerComponent = targetEntity.getComponent(ofType: OwnershipComponent.self) else { return nil }
        
        for entityID in ownerComponent.ownedEntityIDS {
            if let entity = ecsManager.getEntity(entityID), entity.type == kPickaxe  {
                return entity
            }
        }
        
        return nil
    }
    
    /// 获取小手
    static func getHand(targetEntity: RMEntity, ecsManager: ECSManager) -> RMEntity? {
        guard let ownerComponent = targetEntity.getComponent(ofType: OwnershipComponent.self) else { return nil }
        
        for entityID in ownerComponent.ownedEntityIDS {
            if let entity = ecsManager.getEntity(entityID), entity.type == kPickHand  {
                return entity
            }
        }
        
        return nil
    }
    
}
