//
//  DoTask+Hauling.swift
//  RimWorld
//
//  Created by wu on 2025/7/7.
//

import Foundation

/// 搬运任务分为两步，第一走到需要搬运的物品处，第二搬运物品至目标处
extension DoTaskSystem {
    
    /// 强制停止搬运任务
    func cancelHaulingAction(entity: RMEntity,
                               task: WorkTask) {
        
    }
    
    /// 设置搬运任务
    func setHaulingAction(entity: RMEntity,
                          task: WorkTask) {
        
        guard let materialEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("执行的被搬运的目标没有了！💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.haulingTask.targetID) else {
            
            ECSLogger.log("执行的搬运的存储目标没有了！💀💀💀")
         
            /// 取消任务
            RMEventBus.shared.requestForceCancelTask(entity: entity, task: task)
            
            return
        }
        
        /// 执行人
        let executorEntity = entity
        
   
        /// 先走到搬运目标
        if task.haulingTask.haulStage == .movingToItem {
            
            task.haulingTask.haulStage = .movingToTarget
            
            step1ToMoveMaterial(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
            
        }else if task.haulingTask.haulStage == .movingToTarget {
            
            step2ToMoveTarget(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }
        
    }
    
    /// 1 先走到要搬运的材料地方
    func step1ToMoveMaterial(executorEntity: RMEntity,
                             materialEntity: RMEntity,
                             targetEntity: RMEntity,
                             task: WorkTask) {
        
        /// 搬运物是否在存储区域
        let isInStorage = EntityInfoTool.isInStorage(entity: materialEntity, ecsManager: ecsManager)
        
        
        if isInStorage {
            
            if targetEntity.type == kStorageArea {
                
                /// from -> storage  to -> storage
                fromStorageToStorage1(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
                
            } else if targetEntity.type == kBlueprint {
                
                /// from -> storage  to -> blueprint
                fromStorageToBlueprint1(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
            }
            
        }else {
            
          
            if targetEntity.type == kStorageArea {
                
                /// from -> land  to -> storage
                fromLandToStorage1(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
                
            } else if targetEntity.type == kBlueprint {
                
                /// from -> land  to -> blueprint
                fromLandToBlueprint1(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
            }
            
        }
    }
    
    
    /// 2 走到目的地
    func step2ToMoveTarget(executorEntity: RMEntity,
                           materialEntity: RMEntity,
                           targetEntity: RMEntity,
                           task: WorkTask) {
        
        /// 搬运第二步，肯定不是在仓库了
        /// 所以第二步只有目的地不同的问题
        
        if targetEntity.type == kStorageArea {
            /// to -> storage
            toStorage2(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
            
        } else if targetEntity.type == kBlueprint {
            /// to -> blueprint
            toBlueprint2(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }
        
        
        /// 完成任务
        EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
    }
    
 
 
    
    /// 从普通区域搬出来
    func haulingFromLand(lastCount: Int,
                         actualHaul: Int,
                         material: RMEntity){
        
        if lastCount <= 0 { return }
        
        // 👉 创建一个新的需求节点，代表剩余 remainingNeed 数量需要搬运
        let woodPoint = PositionTool.nowPosition(material)
        let params = HarvestParams(
            harvestCount: lastCount
        )
        
        RMEventBus.shared.requestCreateEntity(type: kWood,
                                              point: woodPoint,
                                              params: params)
        
        EntityActionTool.setHaulingCount(entity: material, count: actualHaul)
        
    }
    
    
    /// 从存储区域搬运出来
    func haulingFromStorage(lastCount: Int,
                            actualHaul: Int,
                            material: RMEntity) {
        
        guard let storageEntity = EntityActionTool.storageEntity(entity: material,ecsManager: ecsManager) else {
            return
        }
        
        /// 设置搬运走的数量
        EntityActionTool.setHaulingCount(entity: material, count: actualHaul)
        
        /// 从仓库中分离出来
        OwnerShipTool.detachFromStorage(storage: storageEntity, owned: material, lastCount: lastCount, ecsManager: ecsManager)
        
    }
}




/// 搬运基础逻辑
/// 1. from: land（场景地图）  to: storage（仓库）
extension DoTaskSystem {
    
    func fromLandToStorage1(executorEntity: RMEntity,
                            materialEntity: RMEntity,
                            targetEntity: RMEntity,
                            task: WorkTask){
        
        /// 走到目的地，计算搬运人当前负重
        let capacity = EntityInfoTool.remainingCarryCapacity(executorEntity)
        /// 当前物品单个重量
        let singleWeight = EntityInfoTool.haulingWeight(materialEntity)
        /// 当前物品数量
        let haulCount = EntityInfoTool.haulingCount(materialEntity)
        /// 当前仓库最大载容量
        let needCount = EntityInfoTool.maxStorageCapacity(storage: targetEntity)
        /// 执行人能搬运的数量
        let carryCount = Int(capacity / singleWeight)
        
       
        let possibleCount = min(carryCount, haulCount)
        let actualHaul = min(possibleCount, needCount)
        
        /// 实际搬运数量
        task.haulingTask.currentCount = actualHaul
        
        // 剩余
        let lastCount = haulCount - actualHaul
        
        /// 如果有剩余，生成新的素材
        haulingFromLand(lastCount: lastCount, actualHaul: actualHaul, material: materialEntity)
        
        
        /// 重新设置从属关系
        OwnerShipTool.handleOwnershipChange(newOwner: executorEntity, owned: materialEntity, ecsManager: ecsManager)
        /// 更换父视图
        RMEventBus.shared.requestReparentEntity(entity: materialEntity, z: 100, point: CGPoint(x: 0, y: 0))
        
        
        let startPoint = PositionTool.nowPosition(executorEntity)

        /// 具体对应的格位置
        let saveSizePoint = PositionTool.saveAreaEmptyPosition(saveArea: targetEntity)
        let savePoint = PositionTool.nowPosition(targetEntity)
        let endPoint = CGPoint(x: savePoint.x + saveSizePoint.x, y: savePoint.y + saveSizePoint.y)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
        
    }
    
    func toStorage2(executorEntity: RMEntity,
                            materialEntity: RMEntity,
                            targetEntity: RMEntity,
                            task: WorkTask){
        
        /// 将素材放入到存储区域
        OwnerShipTool.handleOwnershipChange(newOwner: targetEntity, owned: materialEntity, ecsManager: ecsManager)
    }
    
}


/// 2. from: land（场景地图）  to: blueprint（蓝图）
extension DoTaskSystem {
    
    func fromLandToBlueprint1(executorEntity: RMEntity,
                              materialEntity: RMEntity,
                              targetEntity: RMEntity,
                              task: WorkTask){
        guard let categorizationComponent = materialEntity.getComponent(ofType: CategorizationComponent.self) else {
            return
        }
        
        /// 走到目的地，计算搬运人当前负重
        let capacity = EntityInfoTool.remainingCarryCapacity(executorEntity)
        /// 当前物品单个重量
        let singleWeight = EntityInfoTool.haulingWeight(materialEntity)
        /// 当前物品数量
        let haulCount = EntityInfoTool.haulingCount(materialEntity)
        /// 当前蓝图需要的数量
        let needCount = EntityInfoTool.blueprintNeedCount(targetEntity, categorizationComponent.categorization)
        /// 执行人能搬运的数量
        let carryCount = Int(capacity / singleWeight)
        
       
        let possibleCount = min(carryCount, haulCount)
        let actualHaul = min(possibleCount, needCount)
        
        /// 实际搬运数量
        task.haulingTask.currentCount = actualHaul
        
        /// 不等，说明重置搬运任务
        if actualHaul != task.haulingTask.needMaxCount {
            /// 设置蓝图对应搬运任务的实际数量
            EntityActionTool.setBlueprintHaulTaskCount(entity: materialEntity,blueEntity: targetEntity, count: actualHaul)
            RMEventBus.shared.requestReloadHaulingTasks(material: EntityInfoTool.materialType(materialEntity))
        }
        
     

        // 剩余
        let lastCount = haulCount - actualHaul
        
        /// 如果有剩余，生成新的素材
        haulingFromLand(lastCount: lastCount, actualHaul: actualHaul, material: materialEntity)
        
        /// 重新设置从属关系
        OwnerShipTool.handleOwnershipChange(newOwner: executorEntity, owned: materialEntity, ecsManager: ecsManager)
        /// 更换父视图
        RMEventBus.shared.requestReparentEntity(entity: materialEntity, z: 100, point: CGPoint(x: 0, y: 0))
        
        
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = PositionTool.nowPosition(targetEntity)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
    
    func toBlueprint2(executorEntity: RMEntity,
                              materialEntity: RMEntity,
                              targetEntity: RMEntity,
                              task: WorkTask){
        
        guard let materialHaulComponent = materialEntity.getComponent(ofType: HaulableComponent.self),
              let materialTypeComponent = materialEntity.getComponent(ofType: CategorizationComponent.self),
              let blueprintComponent = targetEntity.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        /// 种类
        let key = "\(materialTypeComponent.categorization)"
        /// 当前种类还有的count
        let existingCount = blueprintComponent.alreadyMaterials[key]!
        /// 当前运送过来的数量
        let pushCount = materialHaulComponent.currentCount
        
        let type = EntityInfoTool.materialType(materialEntity)
        
        
        /// 更新一下
        blueprintComponent.alreadyMaterials[key] = pushCount + existingCount
        blueprintComponent.alreadyCreateHaulTask[type]?[materialEntity.entityID] = 0
        
                
        /** 两种方式，1是直接移除，2是不移除，绑定关系 */
        /// 删除这个原件
        RMEventBus.shared.requestRemoveEntity(materialEntity)
        
//        /// 重新设置从属关系
//        OwnerShipTool.handleOwnershipChange(newOwner: targetEntity, owned: materialEntity, ecsManager: ecsManager)
//        /// 更换父视图
//        RMEventBus.shared.requestReparentEntity(entity: materialEntity, z: 100, point: CGPoint(x: 0, y: 0))
      
        /// 不删除，所有者非仓库，不能搬运
//        RMEventBus.shared.requestRemoveFromHaulCategory(entity: materialEntity)
        
        
        /// 更新蓝图界面
        RMInfoViewEventBus.shared.publish(.updateBlueprint)
        
        
        /// 如果完成搬运，发布建造任务
        let materials = blueprintComponent.materials
        let currentMaterials = blueprintComponent.alreadyMaterials
        
        
        targetEntity.node?.texture = TextureManager.shared.getTexture("bluePrint2")
        

        for (key,maxCount) in materials {
            let currentCount = currentMaterials[key]!
            if currentCount < maxCount {
                return
            }
        }
        
        /// 发布建造任务
        RMEventBus.shared.requestBuildTask(targetEntity)
    }
    
}


/// 3. from: storage（仓库） to：storage（仓库）
extension DoTaskSystem {
    
    func fromStorageToStorage1(executorEntity: RMEntity,
                              materialEntity: RMEntity,
                              targetEntity: RMEntity,
                              task: WorkTask){
        
        /// 走到目的地，计算搬运人当前负重
        let capacity = EntityInfoTool.remainingCarryCapacity(executorEntity)
        /// 当前物品单个重量
        let singleWeight = EntityInfoTool.haulingWeight(materialEntity)
        /// 当前物品数量
        let haulCount = EntityInfoTool.haulingCount(materialEntity)
        /// 当前仓库最大载容量
        let needCount = EntityInfoTool.maxStorageCapacity(storage: targetEntity)
        /// 执行人能搬运的数量
        let carryCount = Int(capacity / singleWeight)
        
       
        let possibleCount = min(carryCount, haulCount)
        let actualHaul = min(possibleCount, needCount)
        
        /// 实际搬运数量
        task.haulingTask.currentCount = actualHaul
        
        // 剩余
        let lastCount = haulCount - actualHaul
        
        haulingFromStorage(lastCount: lastCount, actualHaul: actualHaul, material: materialEntity)
        
        
        /// 重新设置从属关系
        OwnerShipTool.handleOwnershipChange(newOwner: executorEntity, owned: materialEntity, ecsManager: ecsManager)
        /// 更换父视图
        RMEventBus.shared.requestReparentEntity(entity: materialEntity, z: 100, point: CGPoint(x: 0, y: 0))
        
        
        let startPoint = PositionTool.nowPosition(executorEntity)

        /// 具体对应的格位置
        let saveSizePoint = PositionTool.saveAreaEmptyPosition(saveArea: targetEntity)
        let savePoint = PositionTool.nowPosition(targetEntity)
        let endPoint = CGPoint(x: savePoint.x + saveSizePoint.x, y: savePoint.y + saveSizePoint.y)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }

    
}


/// 4. from: storage（仓库） to: blueprint（蓝图）
extension DoTaskSystem {
    
    func fromStorageToBlueprint1(executorEntity: RMEntity,
                                 materialEntity: RMEntity,
                                 targetEntity: RMEntity,
                                 task: WorkTask){
        
        guard let categorizationComponent = materialEntity.getComponent(ofType: CategorizationComponent.self) else {
            return
        }
        
        /// 走到目的地，计算搬运人当前负重
        let capacity = EntityInfoTool.remainingCarryCapacity(executorEntity)
        /// 当前物品单个重量
        let singleWeight = EntityInfoTool.haulingWeight(materialEntity)
        /// 当前物品数量
        let haulCount = EntityInfoTool.haulingCount(materialEntity)
        /// 当前蓝图需要的数量
        let needCount = EntityInfoTool.blueprintNeedCount(targetEntity, categorizationComponent.categorization)
        /// 执行人能搬运的数量
        let carryCount = Int(capacity / singleWeight)
        
       
        let possibleCount = min(carryCount, haulCount)
        let actualHaul = min(possibleCount, needCount)
        
        /// 实际搬运数量
        task.haulingTask.currentCount = actualHaul
   
        /// 不等，说明重置搬运任务
        if actualHaul != task.haulingTask.needMaxCount {
            /// 设置蓝图对应搬运任务的实际数量
            EntityActionTool.setBlueprintHaulTaskCount(entity: materialEntity,blueEntity: targetEntity, count: actualHaul)
            RMEventBus.shared.requestReloadHaulingTasks(material: EntityInfoTool.materialType(materialEntity))
        }
        
        // 剩余
        let lastCount = haulCount - actualHaul
        
        haulingFromStorage(lastCount: lastCount, actualHaul: actualHaul, material: materialEntity)
        
        
        /// 重新设置从属关系
        OwnerShipTool.handleOwnershipChange(newOwner: executorEntity, owned: materialEntity, ecsManager: ecsManager)
        /// 更换父视图
        RMEventBus.shared.requestReparentEntity(entity: materialEntity, z: 100, point: CGPoint(x: 0, y: 0))
        
        
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = PositionTool.nowPosition(targetEntity)
        
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
}
