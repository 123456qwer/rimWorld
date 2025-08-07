//
//  ECS+ResourceHarvest.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 处理移除实体后，可能会生成子类的问题
extension ECSManager {
    
    func handleRemovalAndHarvestCreation(_ entity: RMEntity,
                                         reason: RemoveReason?){
        systemManager.getSystem(ofType: ResourceHarvestSystem.self)?.handleRemovalAndHarvestCreation(entity: entity, reason: reason)
    }
    
}
