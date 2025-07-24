//
//  ECS+EnergySystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 能量系统
extension ECSManager {
    
    /// 修改休息状态
    func restStatusAction(entity: RMEntity, isRest: Bool){
        systemManager.getSystem(ofType: EnergySystem.self)?.restStatusAction(entity: entity, isRest: isRest)
    }
}
