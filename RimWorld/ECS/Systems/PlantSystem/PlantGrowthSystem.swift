//
//  PlantGrowthSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/8.
//

import Foundation

/// 植物成长
class PlantGrowthSystem: System {
    
    let ecsManager: ECSManager
    
    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
    var index = 0
    
    /// 待执行的创建任务
    var pendingEntities: [(type: String, point: CGPoint, params: HarvestParams)] = []

    
    init(ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    
    func growUpdate(currentTick: Int) {
        var elapsedTicks = currentTick - lastProcessedTick
        /// 首次进入
        if lastProcessedTick == 0 {
            elapsedTicks = 0
        }
        lastProcessedTick = currentTick
        
//        if lastProcessedTick % 1 == 0 {
//            updateFor1Second()
//        }
        
        
        let plants = ecsManager.entitiesAbleToPlantGrowth()
        let tick = Float(elapsedTicks)
        for plant in plants {
            guard let plantComponent = plant.getComponent(ofType: PlantBasicInfoComponent.self) else { continue }
            
            plantComponent.growthPercent += plantComponent.growthSpeed * tick
            plantComponent.growthPercent = min(1, plantComponent.growthPercent)
            
            if plantComponent.growthPercent > 0.5 {
                if let apple = EntityInfoTool.getSubEntityWithType(targetEntity: plant, ecsManager: ecsManager, type: kApple) {
                    apple.node?.isHidden = false
                }
            }else{
                if let apple = EntityInfoTool.getSubEntityWithType(targetEntity: plant, ecsManager: ecsManager, type: kApple) {
                    apple.node?.isHidden = true
                }
            }
            
            /// 为1以后，直接移除，不需要在成长了
            if plantComponent.growthPercent == 1 {
                ecsManager.removeGrowthEntity(plant)
            }
            
            if let apple = EntityInfoTool.getSubEntityWithType(targetEntity: plant, ecsManager: ecsManager, type: kApple) {
                apple.node?.setScale(CGFloat(plantComponent.growthPercent))
            }
        }
        
        /// 树长大
        RMInfoViewEventBus.shared.requestPlantInfo()
        
        
    }
    
    /// 每秒更新1次
    func updateFor1Second(){
        if let task = pendingEntities.first {
            RMEventBus.shared.requestCreateEntity(type: task.type, point: task.point, params: task.params)
            pendingEntities.remove(at: 0)
        }
        
        index += 1
        print(index)
    }
    
    
}
