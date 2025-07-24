//
//  DoTask+Rest.swift
//  RimWorld
//
//  Created by wu on 2025/7/7.
//

import Foundation

/// Rest
extension DoTaskSystem {

    /// 强制停止休息任务
    func cancelRestingAction(entity: RMEntity,
                             task: WorkTask){
        
    }
    
    /// 开始休息
    func restAction (entityID: Int,
                     task: WorkTask,
                     tick: Int) {
        
        guard let executorEntity = ecsManager.getEntity(entityID) else {
            ECSLogger.log("未找到休息执行人！💀💀💀")
            return
        }
        
        guard let energyComponent = executorEntity.getComponent(ofType: EnergyComponent.self) else {
            ECSLogger.log("👻👻开始休息动画失败，未找到执行人能量组件")
            return
        }
        
        /// 休息动画
        EntityNodeTool.restAnimation(entity: executorEntity, tick: tick)
        
        /// 恢复速度
        let speed = 0.04 * Double(tick)
    
        energyComponent.current += speed
        
        /// 未休息完
        if energyComponent.current < energyComponent.total {
            return
        }
       
        
        /// 休息完
        restingTasks.removeValue(forKey: entityID)
       
        energyComponent.current = energyComponent.total
        energyComponent.isResting = false
        energyComponent.alreadySend = false
        energyComponent.zeroSend = false

        /// 实体休息状态改变，监听的view会变化
        RMEventBus.shared.publish(.restStatusChange(entity: executorEntity, isRest: false))
        
        /// 停止休息动画
        EntityNodeTool.endRestAnimation(entity: executorEntity)
           
        /// 休息结束，完成任务
        EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
    }
}
