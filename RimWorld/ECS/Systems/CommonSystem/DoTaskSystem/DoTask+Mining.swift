//
//  DoTask+Mining.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
/// Mining
extension DoTaskSystem {
    
    /// 强制结束砍树任务
    func cancelMiningAction(entity: RMEntity,
                             task: WorkTask) {
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("强制停止砍伐任务失败，没有找到目标实体：\(entity.name)！💀💀💀")
            return
        }
        
        miningTasks.removeValue(forKey: entity.entityID)
        EntityNodeTool.stopCuttingAnimation(entity: targetEntity)
    }
    
    
    
    func setMiningAction(entity: RMEntity, task: WorkTask) {
        miningTasks[entity.entityID] = task
    }
    
    
    
    /// 执行砍树命令
    func executeMiningAction(executorEntityID: Int,
                              task: WorkTask,
                              tick: Int){
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("未找到挖掘的目标实体💀💀💀")
            return
        }
        guard let targetNode = targetEntity.node else {
            ECSLogger.log("未找到挖掘的目标💀💀💀")
            return
        }
        guard let executorEntity = ecsManager.getEntity(executorEntityID) else {
            ECSLogger.log("未找到挖掘实体💀💀💀")
            return
        }
        guard executorEntity.node != nil else {
            ECSLogger.log("未找到挖掘实体对应的Node：\(executorEntity.name)💀💀💀")
            return
        }
        guard let targetBasicComponent = targetEntity.getComponent(ofType: MiningComponent.self) else {
            ECSLogger.log("这个挖掘目标没有对应的详情组件💀💀💀")
            return
        }
        
        /// 停止挖掘
        if EntityAbilityTool.ableToMarkMine(targetEntity, ecsManager) == false {
            return
        }
        
        /// 挖掘速度  基础值0.4 / tick  约等于 0.4 * 60  24 / s
        let cuttingSpeed = 0.4 * Double(tick)
        /// 挖掘
        targetBasicComponent.mineCurrentHealth -= cuttingSpeed

        /// 挖掘完毕
        if targetBasicComponent.mineCurrentHealth <= 0 {
            

            /// 砍伐结束动画
            EntityNodeTool.cuttingFinish(targetNode: targetNode)
          
            
            /// 矿产
            let removeReason = MineRemoveReason(entity: targetEntity)
            
            /// 删除被挖掘的矿产
            RMEventBus.shared.requestRemoveEntity(targetEntity,reason:removeReason)
            
            /// 删除
            miningTasks.removeValue(forKey: executorEntity.entityID)

            /// 完成任务
            EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
        }else{
            
            /// 砍伐动画
            targetNode.miningAnimation()
            targetNode.barAnimation(total: targetBasicComponent.mineHealth, current: targetBasicComponent.mineCurrentHealth)
        }
        
    }
    
}


