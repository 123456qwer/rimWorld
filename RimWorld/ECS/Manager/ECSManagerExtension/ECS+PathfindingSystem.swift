//
//  ECS+PathfindingSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 寻路系统
extension ECSManager {
    /// 开始寻路
    func startFind(entity:RMEntity,
                   start:CGPoint,
                   end:CGPoint,
                   task:WorkTask){
        systemManager.getSystem(ofType: PathfindingSystem.self)?.startFind(entity: entity, start: start, end: end, task: task)
    }
    
    /// 强制停止寻路
    func pathFindingSystemEndFind(task: WorkTask) {
        systemManager.getSystem(ofType: PathfindingSystem.self)?.endFind(task: task)
    }
}
