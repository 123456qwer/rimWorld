//
//  SystemManager.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

/// 系统调度器
import Foundation
import Combine

class SystemManager {
    
    private var systems: [ObjectIdentifier: System] = [:]

    func addSystem<T: System>(_ system: T) {
        systems[ObjectIdentifier(T.self)] = system
    }

    func getSystem<T: System>(ofType type: T.Type) -> T? {
        return systems[ObjectIdentifier(T.self)] as? T
    }

    func getSystems() -> [System] {
        return Array(systems.values)
    }

    func update(deltaTime: TimeInterval) {
//        for system in systems.values {
//            system.update(deltaTime: deltaTime)
//        }
    }
}
