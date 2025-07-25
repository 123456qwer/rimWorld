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
            addBuildTask(entity)
        }
    }
    
    
    @discardableResult
    func addBuildTask(_ entity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Building, targetEntityID: entity.entityID, executorEntityID: 0)
        taskQueue.append(task)
        sortTaskQueue()
        
        return task
    }
    
    
    func handleBuildTask(_ task: WorkTask) {
        
        guard let target = ecsManager.getEntity(task.targetEntityID) else {
            return
        }
        
        guard let blueprintComponent = target.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        /// 已经分配过的不去处理了
        if task.isInProgress {
            
            /// 检测是否所有材料都齐全
            var allAlready = true
            for (material, maxCount) in blueprintComponent.materials {
                
                let alreadyCount = blueprintComponent.alreadyMaterials[material]
                if alreadyCount != maxCount {
                    allAlready = false
                }
            }
            
            /// 需要去执行建造任务
            if allAlready {
                task.isMaterialComplete = true
                handleCompleteMaterialBuildingTask(task: task)
            }
            
            return
        }
        
     
        task.isInProgress = true
        
        /// 蓝图位置
        let blueprintPoint = CGPoint(x: blueprintComponent.tileX, y: blueprintComponent.tileY)

        /// 是否材料齐全
        var allMaterialComplete = true
       
        /// 材料type,所需数量
        for (material, maxCount) in blueprintComponent.materials {
            
            let existingCount = blueprintComponent.alreadyMaterials[material]
            /// 当前材料齐全，不用在搬运了
            if existingCount == maxCount {
                continue
            }
            allMaterialComplete = false
            let materialType = MaterialType(rawValue: Int(material)!)
            
            if let materialsEntities = ecsManager.entitiesAbleToMaterial(key: materialType!) {
                
                /// 距离最近的素材
                var nearEntity: RMEntity?
                var distance : CGFloat = 1000000
                /// 存在的素材
                for realMaterial in materialsEntities {
                    if let pointComponent = realMaterial.getComponent(ofType: PositionComponent.self) {
                        let d = MathUtils.distance(CGPoint(x: pointComponent.x, y: pointComponent.y), blueprintPoint)
                        if d < distance {
                            nearEntity = realMaterial
                            distance = d
                        }
                    }
                }
                
                if let nearEntity = nearEntity {
                    addHaulingTaskForBuild(nearEntity, task.targetEntityID)
                }
            }
        }
        
        /// 材料齐全，走建造方法
        if allMaterialComplete {
            task.isMaterialComplete = true
            handleCompleteMaterialBuildingTask(task: task)
        }
    }
    
    /// 处理原材料已经填好的蓝图任务
    func handleCompleteMaterialBuildingTask(task: WorkTask) {
        
        
        let exectorEntity = ableToDoTaskEntity(ableEntities: ecsManager.entitiesAbleToBuild(), task: task)
        guard let exectorEntity = exectorEntity else {
            ECSLogger.log("此建造任务无人可用，💀💀💀")
            return
        }
        
        guard let taskComponent = exectorEntity.getComponent(ofType: TaskQueueComponent.self) else {
            return
        }
        
        /// 执行人当前有其他任务，需要强制转换
        if let execturfirstTask = taskComponent.tasks.first {
            
            RMEventBus.shared.requestForceSwitchTask(entity: exectorEntity, task: execturfirstTask)
            /// 移除之前执行的任务
            EntityActionTool.removeTask(entity: exectorEntity, task: execturfirstTask)
            
        }
        
  
        
        removeNotDoTask(task: task)
        doTaskQueue.insert(task)
        
        task.executorEntityID = exectorEntity.entityID
        taskComponent.tasks.insert(task, at: 0)
        EntityActionTool.doTask(entity: exectorEntity)
    }
    
    /// 单独个人的建造任务
    func handleBuildingTaskWithEntity(task: WorkTask,
                                    entity: RMEntity) {
        handleBuildTask(task)
    }
}





/// 增删改查，要同时刷新任务列表
extension CharacterTaskSystem {
    
    func refreshBuildTask (_ entity: RMEntity){
        
        let task = addBuildTask(entity)
        handleBuildTask(task)
        
        /// 重新分配任务
        let haulTasks = taskQueue.filter{ $0.type == .Hauling }
        for task in haulTasks {
            handleHaulingTask(task)
        }
        
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
