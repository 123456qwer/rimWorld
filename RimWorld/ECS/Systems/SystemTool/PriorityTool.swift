//
//  PriorityTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 优先级工具类 🚩 -
/// 优先级工具类
struct PriorityTool {
    
    /// 建造优先级
    static func buildPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self){
            return workComponent.building
        }
        return 0
    }
    
    /// 割除优先级
    static func cuttingPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self){
            return workComponent.cutting
        }
        return 0
    }
    
    /// 搬运优先级
    static func haulingPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            return workComponent.hauling
        }
        return 0
    }

    /// 存储优先级
    static func storagePriority(_ entity: RMEntity) -> Int {
        if let storageComponent = entity.getComponent(ofType: StorageInfoComponent.self) {
            return storageComponent.priority
        }
        return 0
    }

}
