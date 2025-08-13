//
//  TaskSystem+Eat.swift
//  RimWorld
//
//  Created by wu on 2025/8/5.
//

import Foundation

/// 饥饿值降低到一定程度，触发吃饭任务
extension TaskSystem {
    
    /// 新增吃饭任务
    @discardableResult
    func addEatTask(_ entity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .None,
                            targetEntityID: entity.entityID,
                            executorEntityID: entity.entityID)
   
        task.hightType = .Eat
    
        task.eatTask.targetID = getFoodEntityID(entity: entity)
        
        allTaskQueue.append(task)
        assignTask(executorEntity: entity)
        return task
    }
    
    
    func getFoodEntityID(entity: RMEntity) -> Int{
        let foods = ecsManager.entitiesAbleToBeEat()
    
        let execuotrPoint = PositionTool.nowPosition(entity)
    
        var sortFoods = foods.sorted {
            
            let point1 = PositionTool.nowPositionForScene($0, provider: provider)
            let point2 = PositionTool.nowPositionForScene($1, provider: provider)
        
            let distance1 = MathUtils.distance(point1, execuotrPoint)
            let distance2 = MathUtils.distance(point2, execuotrPoint)
        
            return distance1 < distance2
        }
        
        /// 移除已经在任务中的食物
        sortFoods.removeAll(where: {

            let id = $0.entityID
            
            func matches(_ task: WorkTask) -> Bool {
                id == task.targetEntityID || id == task.eatTask.targetID
            }
            
            return allTaskQueue.contains(where: matches) || doTaskQueue.contains(where: matches)
        })
        
        
        /// 如果有，设置target
        if let firstFood = sortFoods.first {
            return firstFood.entityID
        }
        
        return 0
    }
    
    
    /// 处理吃饭任务
    func handleEatTask(executorEntity: RMEntity, task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
    
}




/// 执行吃饭任务
extension TaskSystem {
    
    func doEatTask(_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("吃饭任务未找到执行人！ 💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.eatTask.targetID) else {
            ECSLogger.log("吃饭任务未找饭！ 💀💀💀")
            return
        }
        
        
         let startPoint = PositionTool.nowPosition(executorEntity)
         let endPoint = PositionTool.nowPosition(targetEntity)
         
         RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
        
    }
    
}
