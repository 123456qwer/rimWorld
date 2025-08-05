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
        
        let plants = ecsManager.entitiesAbleToPlantGrowth()
        let tick = Float(elapsedTicks)
        for plant in plants {
            guard let plantComponent = plant.getComponent(ofType: PlantBasicInfoComponent.self) else { continue }
            
            plantComponent.growthPercent += plantComponent.growthSpeed * tick
            plantComponent.growthPercent = min(1, plantComponent.growthPercent)
            /// 为1以后，直接移除，不需要在成长了
            if plantComponent.growthPercent == 1 {
                ecsManager.removeGrowthEntity(plant)
            }
        }
        
        /// 树长大
        RMInfoViewEventBus.shared.requestTreeInfo()
    }
}
