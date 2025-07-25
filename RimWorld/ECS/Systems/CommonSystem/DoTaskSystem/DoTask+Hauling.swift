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
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID2) else {
            ECSLogger.log("执行的搬运的存储目标没有了！💀💀💀")
            return
        }
        
        /// 执行人
        let executorEntity = entity
        
   
        /// 先走到搬运目标
        if task.haulStage == .movingToItem {
            
            task.haulStage = .movingToTarget
            
            step1ToMoveMaterial(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
            
        }else if task.haulStage == .movingToTarget {
            
            step2ToMoveTarget(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }
        
    }
    
    /// 1 先走到要搬运的材料地方
    func step1ToMoveMaterial(executorEntity: RMEntity,
                             materialEntity: RMEntity,
                             targetEntity: RMEntity,
                             task: WorkTask) {
        
        
        if targetEntity.type == kStorageArea {
            step1ForSaveArea(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }else if targetEntity.type == kBlueprint {
            step1ForBlueprint(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }
      
        
        start1StepCommonAction(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
    }
    
    
    /// 2 走到目的地
    func step2ToMoveTarget(executorEntity: RMEntity,
                           materialEntity: RMEntity,
                           targetEntity: RMEntity,
                           task: WorkTask) {
        if targetEntity.type == kStorageArea {
            step2ForSaveArea(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }else if targetEntity.type == kBlueprint {
            step2ForBlueprint(executorEntity: executorEntity, materialEntity: materialEntity, targetEntity: targetEntity, task: task)
        }
        
        
        /// 完成任务
        EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
    }
    
  
    /// 通用搬运1
    func start1StepCommonAction(executorEntity: RMEntity,
                                materialEntity: RMEntity,
                                targetEntity: RMEntity,
                                task: WorkTask){
        /// 重新设置从属关系
        OwnerShipTool.handleOwnershipChange(owner: executorEntity, owned: materialEntity, ecsManager: ecsManager)
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

/// 搬运到蓝图逻辑
extension DoTaskSystem {
    /// 1 搬运材料至蓝图逻辑
    func step1ForBlueprint(executorEntity: RMEntity,
                           materialEntity: RMEntity,
                           targetEntity: RMEntity,
                           task: WorkTask) {
        
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

        // 👉 创建这次搬运任务，搬 actualHaul 数量
        let lastCount = haulCount - actualHaul
        if lastCount > 0 {
            
            // 👉 创建一个新的需求节点，代表剩余 remainingNeed 数量需要搬运
            let woodPoint = PositionTool.nowPosition(materialEntity)
            let params = WoodParams(
                woodCount: lastCount
            )
            
            RMEventBus.shared.requestCreateEntity(type: kWood,
                                                  point: woodPoint,
                                                  params: params)
            
            EntityActionTool.setHaulingCount(entity: materialEntity, count: actualHaul)
            EntityNodeTool.updateHaulCountLabel(entity: materialEntity, count: actualHaul)
        }
        
        
    }
    
    /// 2 搬运材料至蓝图逻辑
    func step2ForBlueprint(executorEntity: RMEntity,
                           materialEntity: RMEntity,
                           targetEntity: RMEntity,
                           task: WorkTask) {
        
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
        
        /// 更新一下
        blueprintComponent.alreadyMaterials[key] = pushCount + existingCount
        
        /// 删除这个原件
        RMEventBus.shared.requestRemoveEntity(materialEntity)
        
        /// 更新蓝图界面
        RMInfoViewEventBus.shared.publish(.updateBlueprint)
        
    }
    
}



/// 搬运到存储区域逻辑
extension DoTaskSystem {
    /// 1 搬运材料至存储区域逻辑
    func step1ForSaveArea(executorEntity: RMEntity,
                                materialEntity: RMEntity,
                                targetEntity: RMEntity,
                                task: WorkTask){

        /// 走到目的地，计算搬运人当前负重
        let capacity = EntityInfoTool.remainingCarryCapacity(executorEntity)
        /// 当前物品单个重量
        let singleWeight = EntityInfoTool.haulingWeight(materialEntity)
        /// 当前物品数量
        let haulCount = EntityInfoTool.haulingCount(materialEntity)
        
    
        /// 需要新生成一个未全部搬运的实体
        if singleWeight * Double(haulCount) > capacity {
            
            let carryCount = Int(capacity / singleWeight)
            let lastCount = haulCount - carryCount
            
            let woodPoint = PositionTool.nowPosition(materialEntity)
            let params = WoodParams(
                woodCount: lastCount
            )
            
            RMEventBus.shared.requestCreateEntity(type: kWood,
                                                  point: woodPoint,
                                                  params: params)
            
            EntityActionTool.setHaulingCount(entity: materialEntity, count: carryCount)
            EntityNodeTool.updateHaulCountLabel(entity: materialEntity, count: carryCount)
        }
        
    }
    
    
    /// 2 搬运材料至存储区域逻辑
    func step2ForSaveArea(executorEntity: RMEntity,
                                materialEntity: RMEntity,
                                targetEntity: RMEntity,
                                task: WorkTask) {
        
        /// 重置拥有关系
        OwnerShipTool.handleOwnershipChange(owner: targetEntity,
                                            owned: materialEntity,
                                            ecsManager: ecsManager)
    }
}
