//
//  DoTask+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation

extension DoTaskSystem {
    
    /// 强制停止建造任务
    func cancelGrowingAction(entity: RMEntity,
                              task: WorkTask) {
        
        
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("强制停止种植任务失败，没有找到目标实体：\(entity.name)！💀💀💀")
            return
        }
        

        targetEntity.node?.zRotation = 0
    }
    
    /// 设置建造任务
    func setGrowingAction(entity: RMEntity,
                             task: WorkTask) {
//        growingTasks[entity.entityID] = task
        executeGrowingAction(executorEntityID: entity.entityID, task: task, tick: 0)
    }
    
    
    /// 执行种植命令
    func executeGrowingAction(executorEntityID: Int,
                              task: WorkTask,
                              tick: Int){
        guard let growAreaEntity = ecsManager.getEntity(task.targetEntityID),
              let growComponent = growAreaEntity.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("此种植任务的区域已经没有了！ 💀💀💀")
            return
        }
        
        guard let executorEntity = ecsManager.getEntity(executorEntityID) else {
            ECSLogger.log("此种植任务的执行人已经没有了！ 💀💀💀")
            return
        }
 
       
        executorEntity.node?.growingAnimation {[weak self] in
            
            guard let self = self else {return}
            
            
            self.finishGrow(task: task, executorEntity: executorEntity, growAreaEntity: growAreaEntity)
        }
     
    }
    
    /// 完成种植动画，生成植物
    func finishGrow(task: WorkTask,
                    executorEntity: RMEntity,
                    growAreaEntity: RMEntity){
        
        guard let growComponent = growAreaEntity.getComponent(ofType: GrowInfoComponent.self) else { return }
        
        let params = PlantParams(ownerId: task.targetEntityID,
                                 cropType: RimWorldCrop(rawValue: growComponent.cropType)!,
                                 saveKey: task.growingTask.emptyIndex)
        
        var type = ""
        switch params.cropType {
        case .rice:
            type = kRice
        default:
            type = kRice
        }
        
        /// 实际植物的位置
        let cropPoint = PositionTool.growAreaCropPoint(area: growAreaEntity, key: task.growingTask.emptyIndex)
        
        RMEventBus.shared.requestCreateEntity(type: type, point: cropPoint, params: params)
        
        executorEntity.node?.zRotation = 0
        /// 完成任务
        EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
    }
    
}
