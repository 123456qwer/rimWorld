//
//  CharacterTaskSystem+Building.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 建造
extension CharacterTaskSystem {
    
    func generateBuildingTask () {
        let bluePrints = ecsManager.entitiesAbleToBeBuild()
        for (_, entity) in bluePrints {
            
            guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
                continue
            }
            
            /// 素材完备才创建建造任务，否则只创建搬运任务
            if blueComponent.isMaterialCompelte {
                addBuildTask(entity)
            }
        }
    }
    
    
    @discardableResult
    func addBuildTask(_ entity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Building,
                            targetEntityID: entity.entityID,
                            executorEntityID: 0)
        allTaskQueue.append(task)
        return task
    }
    
    /// 处理建造任务
    func handleBuildingTask(executorEntity: RMEntity,
                            task:WorkTask) {
        task.executorEntityID = executorEntity.entityID
    }

}





/// 增删改查，要同时刷新任务列表
extension CharacterTaskSystem {
    
    func refreshBuildTask (_ entity: RMEntity){
        

    }
}










/// 执行建造任务
extension CharacterTaskSystem {
    
    /// 执行建造任务
    func doBuildingTask (_ task: WorkTask) {
        
        guard let executorEntity = ecsManager.getEntity(task.executorEntityID) else {
            ECSLogger.log("建造任务未找到执行人，💀💀💀")
            return
        }
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("建造目标已经没有了，💀💀💀")
            return
        }
        
   
        let startPoint = PositionTool.nowPosition(executorEntity)
        let endPoint = PositionTool.nowPosition(targetEntity)
        
        RMEventBus.shared.requestFindingPath(entity: executorEntity, startPoint: startPoint, endPoint: endPoint, task: task)
    }
}



/// 中断建造任务
extension CharacterTaskSystem {
    
    
    func cancelBuilding(entity: RMEntity,
                        task: WorkTask) {
        
        task.executorEntityID = 0
        
        removeDoTask(task: task)
        allTaskQueue.append(task)
    }
}
