//
//  ECS+EntityNodeFactorySystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 创建实体系统
extension ECSManager {
    /// 创建实体
    func createEntity(type: String,
                      point: CGPoint,
                      params: EntityCreationParams){
        
        systemManager.getSystem(ofType: EntityNodeFactorySystem.self)?.createEntity(type: type, point: point, params: params)
    }
}
