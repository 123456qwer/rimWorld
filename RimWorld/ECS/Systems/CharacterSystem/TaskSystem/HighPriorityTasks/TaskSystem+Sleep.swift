//
//  TaskSystem+Sleep.swift
//  RimWorld
//
//  Created by wu on 2025/8/5.
//

import Foundation

/// 精力值降低到一定程度，触发睡觉任务
extension TaskSystem {
    
    /// 新增睡觉任务
    @discardableResult
    func addSleepTask(_ entity: RMEntity) -> WorkTask{
        
        
        let task = WorkTask(type: .None,
                            targetEntityID: entity.entityID,
                            executorEntityID: entity.entityID)
        task.hightType = .Sleep
        allTaskQueue.append(task)
        assignTask(executorEntity: entity)
        return task
    }
    
    
    /// 处理睡觉任务
    func handleSleepingTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
}




extension TaskSystem {
    
    /// 执行睡觉任务
    func doSleepTask(_ task: WorkTask){
        guard let executorEntity = ecsManager.getEntityNode(task.executorEntityID)?.rmEntity else {
            ECSLogger.log("修养任务执行人未找到")
            return
        }
        
       
        guard let executorPointComponent = executorEntity.getComponent(ofType: PositionComponent.self) else {
            ECSLogger.log("修养任务执行人位置有误")
            return
        }
        
        guard let energyComponent = executorEntity.getComponent(ofType: EnergyComponent.self) else {
            ECSLogger.log("修养任务执行人没有能量控件")
            return
        }
        
        let startX = executorPointComponent.x
        let startY = executorPointComponent.y
        
        /// 指定的休息位置
        var endX = executorPointComponent.sleepX == 0 ? startX : executorPointComponent.sleepX
        var endY = executorPointComponent.sleepY == 0 ? startY : executorPointComponent.sleepY
        
        /// 能量为0，直接倒地就睡
        if energyComponent.current == 0 {
            endX = startX
            endY = startY
        }
        
        let startPoint = CGPoint(x: startX, y: startY)
        let endPoint = CGPoint(x: endX, y: endY)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
    
}
