//
//  ECS+MovementSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 移动系统
extension ECSManager {
    /// 移动方法
    func moveAction(points:[CGPoint],
                    entity: RMEntity,
                    task:WorkTask){
        systemManager.getSystem(ofType: MovementSystem.self)?.moveAction(points: points, entity: entity, task: task)
    }
    
    /// 移动系统强制切换
    func movementForceSwitchAction(entity:RMEntity,
                                   task: WorkTask){
        systemManager.getSystem(ofType: MovementSystem.self)?.forceSwitchTask(entityID: entity.entityID, task: task)
    }
}
