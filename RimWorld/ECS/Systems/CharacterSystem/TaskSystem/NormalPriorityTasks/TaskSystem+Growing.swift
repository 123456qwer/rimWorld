//
//  TaskSystem+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 种植
extension TaskSystem {
    
    func generateGrowingTask () {
        
        let grows = ecsManager.entitiesAbleToBeGrowArea()
        for entity in grows {
            guard let growInfoComponent = entity.getComponent(ofType: GrowInfoComponent.self) else { continue }
            let growAllKeys = EntityInfoTool.getGrowingAllKeys(targetEntity: entity)
            for index in growAllKeys {
                /// 不为空，创建植物
                if growInfoComponent.saveEntities[index] == nil {
                    addGrowingTask(entity, emptyIndex: index)
                }
            }
        }
    }
    
    /// 添加种植任务
    @discardableResult
    func addGrowingTask(_ entity: RMEntity,
                        emptyIndex: Int) -> WorkTask? {
    
        guard let growComponent = entity.getComponent(ofType: GrowInfoComponent.self) else { return nil }
        
        let allPoints = PositionTool.getAreaAllPoints(size: growComponent.size)
        
        guard emptyIndex >= 0 && emptyIndex < allPoints.count else {
            ECSLogger.log("越界错误：(\(emptyIndex)) 超出了 allPoints.count (\(allPoints.count))💀💀💀")
            return nil
        }
        
        let point = allPoints[emptyIndex]
        
        let task = WorkTask(type: .Growing,
                            targetEntityID: entity.entityID,
                            executorEntityID: 0)
        
        let savePoint = PositionTool.nowPosition(entity)
        let pointForScene = CGPoint(x: savePoint.x + point.x, y: savePoint.y + point.y)
   
        /// 需要种植的目标位置
        task.growingTask.targetPoint = pointForScene
        task.growingTask.emptyIndex = emptyIndex
        allTaskQueue.append(task)
        
        return task
    }
    

    /// 处理种植任务
    func handleGrowingTask(executorEntity: RMEntity,
                           task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }
}



extension TaskSystem {
    
    /// 执行建造任务
    func doGrowingTask (_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
            ECSLogger.log("建造任务未找到执行人，💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("建造目标已经没有了，💀💀💀")
            return
        }
        
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = task.growingTask.targetPoint
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
}
