//
//  DoTask+Cutting.swift
//  RimWorld
//
//  Created by wu on 2025/7/7.
//

import Foundation

/// Cutting
extension DoTaskSystem {
    
    /// 强制结束砍树任务
    func cancelCuttingAction(entity: RMEntity,
                             task: WorkTask) {
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("强制停止砍伐任务失败，没有找到目标实体：\(entity.name)！💀💀💀")
            return
        }
        
        cuttingTasks.removeValue(forKey: entity.entityID)
        pickingTasks.removeValue(forKey: entity.entityID)
        EntityNodeTool.stopCuttingAnimation(entity: targetEntity)
        
    }
    
    
    
    func setCuttingAction(entity: RMEntity, task: WorkTask) {
        cuttingTasks[entity.entityID] = task
    }
    
    
    
    /// 执行砍树命令
    func executeCuttingAction(executorEntityID: Int,
                              task: WorkTask,
                              tick: Int){
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("未找到砍伐的目标实体💀💀💀")
            return
        }
        guard let targetNode = targetEntity.node else {
            ECSLogger.log("未找到砍伐的目标💀💀💀")
            return
        }
        guard let executorEntity = ecsManager.getEntity(executorEntityID) else {
            ECSLogger.log("未找到砍伐实体💀💀💀")
            return
        }
        guard executorEntity.node != nil else {
            ECSLogger.log("未找到砍伐实体对应的Node：\(executorEntity.name)💀💀💀")
            return
        }
        guard let targetBasicComponent = targetEntity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("这个砍伐目标没有对应的详情组件💀💀💀")
            return
        }
        
        /// 停止砍伐
        if EntityAbilityTool.ableToMarkCut(targetEntity, ecsManager) == false {
            return
        }
        
        /// 砍伐速度  基础值0.4 / tick  约等于 0.4 * 60  24 / s
        let cuttingSpeed = 0.4 * Double(tick)
        /// 砍树
        targetBasicComponent.cropCurrentHealth -= cuttingSpeed

        /// 砍伐完毕
        if targetBasicComponent.cropCurrentHealth <= 0 {
            

            /// 砍伐结束动画
            EntityNodeTool.cuttingFinish(targetNode: targetNode)
          
            
            let removeReason = TreeRemoveReason(entity: targetEntity)
            
            /// 删除被砍伐的木材
            RMEventBus.shared.requestRemoveEntity(targetEntity,reason:removeReason)
            
            /// 删除
            cuttingTasks.removeValue(forKey: executorEntity.entityID)

            /// 完成任务
            EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
        }else{
            
            /// 砍伐动画
            targetNode.cuttingAnimation()
            targetNode.barAnimation(total: targetBasicComponent.cropHealth, current: targetBasicComponent.cropCurrentHealth)
        }
        
    }
    
}


/// Picking
extension DoTaskSystem {
    
    func setPickingAction(entity: RMEntity, task: WorkTask) {
        pickingTasks[entity.entityID] = task
    }
    
    /// 执行采摘命令
    func executePickingAction(executorEntityID: Int,
                              task: WorkTask,
                              tick: Int){
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("未找到采摘的目标实体💀💀💀")
            return
        }
        guard let targetNode = targetEntity.node else {
            ECSLogger.log("未找到采摘的目标💀💀💀")
            return
        }
        guard let executorEntity = ecsManager.getEntity(executorEntityID) else {
            ECSLogger.log("未找到采摘实体💀💀💀")
            return
        }
        guard executorEntity.node != nil else {
            ECSLogger.log("未找到采摘实体对应的Node：\(executorEntity.name)💀💀💀")
            return
        }
        guard let targetBasicComponent = targetEntity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("这个采摘目标没有对应的详情组件💀💀💀")
            return
        }
        
        
        /// 停止采摘
        if EntityAbilityTool.ableToMarkPick(targetEntity, ecsManager) == false {
            return
        }
        
        /// 采摘速度  基础值0.4 / tick  约等于 0.4 * 60  24 / s
        let cuttingSpeed = 0.4 * Double(tick)
        /// 采摘
        targetBasicComponent.pickCurrentHealth -= cuttingSpeed

        /// 采摘完毕
        if targetBasicComponent.pickCurrentHealth <= 0 {
            

            /// 砍伐结束动画
            EntityNodeTool.pickingFinish(targetNode: targetNode)
          
            
            // TODO: - 获取苹果 -
            if let apple = EntityInfoTool.getSubEntityWithType(targetEntity: targetEntity, ecsManager: ecsManager, type: kApple) {
                
                let reason = PickRemoveReason(entity: apple)
                RMEventBus.shared.requestRemoveEntity(apple, reason: reason)
            }
            
            
            /// 删除
            pickingTasks.removeValue(forKey: executorEntity.entityID)

            /// 完成任务
            EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
        }else{
            
            /// 采摘动画
            targetNode.pickingAnimation()
            targetNode.barAnimation(total: targetBasicComponent.pickHealth, current: targetBasicComponent.pickCurrentHealth)
        }
        
    }
}
