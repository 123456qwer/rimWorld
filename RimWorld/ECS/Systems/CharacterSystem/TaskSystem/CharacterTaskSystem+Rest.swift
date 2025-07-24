//
//  CharacterTaskSystem+Rest.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 修养
extension CharacterTaskSystem {
    
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
        
        /// 所有休息任务
        let restTasks = taskQueue.filter{ $0.type == .Rest }
        guard !restTasks.isEmpty else { return }
        
        for task in restTasks {
            guard let entity = ecsManager.getEntity(task.targetEntityID) else { continue }
            task.targetEntityID = entity.entityID
            task.executorEntityID = entity.entityID
            EntityActionTool.addTask(entity: entity, task: task)
        }
        
    }
    
    /// 新增休息任务
    @discardableResult
    func addRestTask(_ entity: RMEntity,
                     _ mustRest:Bool) -> WorkTask{
        
        let task = WorkTask(type: .Rest, targetEntityID: entity.entityID, executorEntityID: 0)
        task.mustDo = mustRest == true ? 1 : -1
        taskQueue.append(task)
        sortTaskQueue()
        
        return task
    }
    
    
    
    /// 执行休息任务
    func handleRestTask(_ task: WorkTask,
                        _ mustRest:Bool) {
        
        guard let executorEntity = ecsManager.getEntityNode(task.targetEntityID)?.rmEntity else {
            ECSLogger.log("休息任务⭐️：未找到对应实体")
            return
        }
        
        guard let taskComponent = executorEntity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("休息任务⭐️：此实体没有任务控件：\(executorEntity.name)")
            return
        }
        
        guard let workPriorityComponent = executorEntity.getComponent(ofType: WorkPriorityComponent.self) else {
            ECSLogger.log("休息任务⭐️：此实体没有工作排序等级：\(executorEntity.name)")
            return
        }
     
        /// 这里需要对比优先级
        if taskComponent.tasks.count > 0 {
            
            /// 当前任务
            let currentTask = taskComponent.tasks.first!

            /// 休息任务
            let taskLevel = EntityInfoTool.workPriority(entity: executorEntity, workType: currentTask.type)
            
            /// 休息任务
            let restLevel = EntityInfoTool.workPriority(entity: executorEntity, workType: .Rest)
            
            /// 必须休息
            if mustRest == true {
                ECSLogger.log("休息任务⭐️：此实体正在执行其他任务：\(executorEntity.name)，但是休息之为0了，必须执行休息任务")
                
            }else if restLevel > taskLevel {
                ECSLogger.log("休息任务⭐️：此实体正在执行其他任务：\(executorEntity.name),任务类型是：\(currentTask.type.rawValue)")
                return
                
            }else if restLevel == taskLevel {
                /// 任务等级相等，根据类型对比左右优先级
                ECSLogger.log("休息任务⭐️：此实体目前执行的任务和休息任务等级一致，对比优先级")
                
                let priorityType = EntityActionTool.compareTaskPriority(type1: .Rest, type2: currentTask.type)
               
                
                if priorityType != .Rest {
                    ECSLogger.log("休息任务⭐️：此实体正在执行其他任务：\(executorEntity.name),任务类型是：\(currentTask.type.rawValue)")
                    return
                }
            }
            
            
        
            /// 将任务终止
            RMEventBus.shared.requestForceSwitchTask(entity: executorEntity, task: currentTask)
            
            /// 移除正在执行的此任务
            EntityActionTool.removeTask(entity: executorEntity, task: currentTask)
            

            
            ECSLogger.log("执行了终止任务⭐️：\(executorEntity.name)")

        }
        
        ECSLogger.log("将休息任务分配到了实体中：\(executorEntity.name)")
        
        removeNotDoTask(task: task)
        doTaskQueue.insert(task)
       
        task.executorEntityID = executorEntity.entityID
        
        /// 将休息任务添加到任务序列中
        EntityActionTool.addTask(entity: executorEntity, task: task)
        EntityActionTool.doTask(entity: executorEntity)
        

        return
    }
    

    
}



/// 执行修养任务
extension CharacterTaskSystem {
    
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
extension CharacterTaskSystem {
    
    
    func cancelRest(entity: RMEntity, task: WorkTask) {
        
    }
    
}
