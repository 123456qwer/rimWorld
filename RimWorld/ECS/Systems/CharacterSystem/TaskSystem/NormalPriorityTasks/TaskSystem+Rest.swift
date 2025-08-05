//
//  TaskSystem+Rest.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 修养
extension TaskSystem {
    
    /// 修养任务
    func generateRestTask() {
        let energys = ecsManager.entitiesAbleToRest()
        for character in energys {
            guard let energyComponent = character.getComponent(ofType: EnergyComponent.self) else {
                ECSLogger.log("此人物没有修养组件：\(character.name)")
                continue
            }
            
            guard let workComponent = character.getComponent(ofType: WorkPriorityComponent.self) else {
                ECSLogger.log("此人物没有工作优先级组件：\(character.name)")
                continue
            }
            
            let threshold: Double = {
                switch workComponent.rest {
                case 3: return energyComponent.threshold3
                case 2: return energyComponent.threshold2
                case 1: return energyComponent.threshold1
                default: return 0.0
                }
            }()
            
            if energyComponent.current <= threshold || energyComponent.isResting{
                energyComponent.alreadySend = true
                let mustDo = energyComponent.current == 0 ? true : false
                if mustDo == true {
                    energyComponent.zeroSend = true
                }
                addRestTask(character, mustDo)
            }
        }
        
    }
    
    /// 初始化时分配休息任务
    func assignInitialRestTasks() {
     
        
    }
    
    /// 新增休息任务
    @discardableResult
    func addRestTask(_ entity: RMEntity,
                     _ mustRest:Bool) -> WorkTask{
        
        
        let task = WorkTask(type: .Rest,
                            targetEntityID: entity.entityID,
                            executorEntityID: entity.entityID)
        allTaskQueue.append(task)
        assignTask(executorEntity: entity)
        return task
    }
    
    
    /// 处理休息任务
    func handleRestingTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
    
}



/// 执行修养任务
extension TaskSystem {
    
    /// 执行修养任务
    func doRestTask(_ task: WorkTask) {
        
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


/// 中断任务
extension TaskSystem {
    
    
    func cancelRest(entity: RMEntity, task: WorkTask) {
        
    }
    
}
