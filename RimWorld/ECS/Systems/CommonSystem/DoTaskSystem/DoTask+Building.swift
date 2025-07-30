//
//  DoTask+Building.swift
//  RimWorld
//
//  Created by wu on 2025/7/25.
//

import Foundation

extension DoTaskSystem {
    
    /// 强制停止建造任务
    func cancelBuildingAction(entity: RMEntity,
                                task: WorkTask) {
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("强制停止建造任务失败，没有找到目标实体：\(entity.name)！💀💀💀")
            return
        }
        
        buildingTasks.removeValue(forKey: entity.entityID)
        EntityNodeTool.stopBuildingAnimation(entity: targetEntity)
    }
    
    /// 设置建造任务
    func setBuildingAction(entity: RMEntity,
                             task: WorkTask) {
        buildingTasks[entity.entityID] = task
    }
    
    
    /// 开始建造
    func executeBuildingAction (executorEntityID: Int,
                                task: WorkTask,
                                tick: Int) {
        guard let blueTargetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("此建造任务的蓝图已经没有了！ 💀💀💀")
            return
        }
        guard let executorEntity = ecsManager.getEntity(executorEntityID) else {
            ECSLogger.log("此建造任务的执行人已经没有了！ 💀💀💀")
            return
        }
        
    
        
        guard let blueprintComponent = blueTargetEntity.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        
        /// 建造速度  基础值0.4 / tick  约等于 0.4 * 60  24 / s
        let cuttingSpeed = 0.4 * Double(tick)
        let allBuildPoints = blueprintComponent.totalBuildPoints
        let currentBuildPoints = blueprintComponent.currentBuildPoints + cuttingSpeed

        blueprintComponent.currentBuildPoints = currentBuildPoints
        
        /// 建造完成
        if currentBuildPoints >= allBuildPoints {
            
            /// 完成任务
            EntityActionTool.completeTaskAction(entity: executorEntity, task: task)
            
            buildComplete(blueTargetEntity: blueTargetEntity, blueprintComponent: blueprintComponent)
            
            buildingTasks.removeValue(forKey: executorEntity.entityID)

            
        }else {
            /// 建造动画
            blueTargetEntity.node?.buildingAnimation()
            blueTargetEntity.node?.barAnimation(total: blueprintComponent.totalBuildPoints, current: blueprintComponent.currentBuildPoints)
        }
        
        /// 刷新蓝图Inof
        RMInfoViewEventBus.shared.requestReloadBlueprintInfo()
    }
    
    
    /// 完成建造任务，生成对应的实体
    func buildComplete(blueTargetEntity:RMEntity,
                       blueprintComponent: BlueprintComponent) {
        
        let type = BlueprintType(rawValue: blueprintComponent.blueprintType)
        switch type {
        case .wall:
            wall(blueprintComponent: blueprintComponent)
        default:
            break
        }
        
        /// 移除蓝图
        RMEventBus.shared.requestRemoveEntity(blueTargetEntity)
    }
    
    
    /// 墙
    func wall(blueprintComponent: BlueprintComponent){
        
        /// 材料类型
        let type = MaterialType(rawValue: Int(blueprintComponent.materials.keys.first!)!)
        let point = CGPoint(x: blueprintComponent.tileX, y: blueprintComponent.tileY)
        
        switch type {
        case .wood:
            
            let params = WallParams(
                material: MaterialType.wood, wallTexture: "woodWall", type: kWoodWall
            )
            RMEventBus.shared.requestCreateEntity(type: kWoodWall, point: point, params: params)
            
        default:
            break
        }
        
    }
    
    
    
    
    
}




