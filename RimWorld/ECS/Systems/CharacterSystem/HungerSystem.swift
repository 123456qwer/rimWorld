//
//  HungerSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import SpriteKit

class HungerSystem: System {
    
    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    /// 初始化饥饿值系统
    func setupHunger(){
     
    }
    
  
    
    func hungerUpdate(currentTick: Int) {
        
        var elapsedTicks = currentTick - lastProcessedTick
        /// 首次进入
        if lastProcessedTick == 0 {
            elapsedTicks = 0
        }
        lastProcessedTick = currentTick
        
        let allEntities = ecsManager.entitiesAbleToEat()
        for entity in allEntities {
            
            guard let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self ) else { continue }
            
            let decay = nutritionComponent.nutritionDecayPerTick * Double(elapsedTicks)

            /// 更新角色实体饥饿值
            nutritionComponent.current -= decay
            /// 最小不小于0
            nutritionComponent.current = max(0, nutritionComponent.current)
            /// 饱食度小于临界值，需要吃饭了
            if nutritionComponent.threshold > nutritionComponent.current {
                ECSLogger.log("饱食度小于临界值，该吃饭了！")
            }
            
        }
        
        RMInfoViewEventBus.shared.requestReloadMoodStatusInfo()
        
    }
    
  

}
    
