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
            ECSLogger.log("未找到砍伐实体")
            return
        }
        guard let executorNode = executorEntity.node else {
            ECSLogger.log("未找到砍伐实体对应的Node：\(executorEntity.name)")
            return
        }
        guard let targetBasicComponent = targetEntity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            ECSLogger.log("这个砍伐目标没有对应的详情组件")
            return
        }
        
        /// 停止砍伐
        if targetBasicComponent.canChop == false {
            return
        }
        
        /// 砍伐速度  基础值0.4 / tick  约等于 0.4 * 60  24 / s
        let cuttingSpeed = 0.4 * Double(tick)
        /// 砍树
        targetBasicComponent.currentHealth -= cuttingSpeed

        /// 砍伐完毕
        if targetBasicComponent.currentHealth <= 0 {
            

            /// 砍伐结束动画
            EntityNodeTool.cuttingFinish(targetNode: targetNode)
            
            /// 树坐标
            let targetPoint = PositionTool.nowPosition(targetEntity)
            
            /// 生成的木头量
            let woodCount = EntityInfoTool.currentHarvestAmount(entity: targetEntity)
            
            /// 生成树大于0，才产生新的木头
            if woodCount > 0 {
                
                let params = WoodParams(
                    woodCount: woodCount
                )
                
                /// 创建木材实体（需要当前这个树来确定生成多少个木头）
                RMEventBus.shared.requestCreateEntity(type: kWood,
                                                      point: targetPoint,
                                                      params: params)
            }
          
            /// 删除被砍伐的木材
            RMEventBus.shared.requestRemoveEntity(targetEntity)
            
            /// 删除
            cuttingTasks.removeValue(forKey: executorEntity.entityID)

            /// 完成任务
            EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
        }else{
            
            /// 砍伐动画
            targetNode.cuttingAnimation()
            targetNode.barAnimation(total: targetBasicComponent.health, current: targetBasicComponent.currentHealth)
        }
        
    }
    
    
    
    
}
