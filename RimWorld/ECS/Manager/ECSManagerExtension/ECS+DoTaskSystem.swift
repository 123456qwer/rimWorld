//
//  ECS+DoTaskSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 执行任务系统（Node动画等）
extension ECSManager {
    
    /// 停止寻路，开始执行任务
    func moveEnd(entity: RMEntity,
                 task: WorkTask){
        systemManager.getSystem(ofType: DoTaskSystem.self)?.moveEnd(entity: entity, task: task)
    }
    
    /// 强制停止正在执行的任务
    func doTaskSystemForceSwitchTask(_ entity: RMEntity,
                                     _ task: WorkTask) {
        systemManager.getSystem(ofType: DoTaskSystem.self)?.forceSwitchTask(entity, task)
    }
}
