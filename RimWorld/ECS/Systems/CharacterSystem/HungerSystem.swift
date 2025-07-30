//
//  HungerSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import SpriteKit

class HungerSystem: System {
    
    /// 角色
    var characters:[RMEntity] = []
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    /// 初始化饥饿值系统
    func setupHunger(){
        /// 更新饥饿值
        NotificationCenter.default.addObserver(self, selector: #selector(updateDropHunger), name: .RMGameTimeHungerTick, object: nil)
        for entity in ecsManager.allEntities() {
            if entity.type == kCharacter {
                characters.append(entity)
            }
        }
    }
    
  
    
    @objc func updateDropHunger(_ notification:NSNotification) {

        for entity in characters {
            
            /// 更新角色实体饥饿值
            if let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self){
                nutritionComponent.current -= nutritionComponent.nutritionDecayPerTick
                /// 最小不小于0
                nutritionComponent.current = max(0, nutritionComponent.current)
                /// 饱食度小于临界值，需要吃饭了
                if nutritionComponent.threshold > nutritionComponent.current {
                    ECSLogger.log("饱食度小于临界值，该吃饭了！")
                }
            }
            
        }
    }
    
    func updateEntities(entities: [RMEntity],
                       rmEntityNodeMap: [Int : RMBaseNode]) {
        characters.removeAll()
        for entity in entities {
            if entity.type == kCharacter {
                characters.append(entity)
            }
        }
    }
    

}
    
