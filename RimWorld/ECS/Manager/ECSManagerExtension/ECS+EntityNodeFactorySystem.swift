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
    func createEntity(_ type: String,
                      _ point: CGPoint,
                      _ size:CGSize?,
                      _ subContent:[String:Any]?){
        systemManager.getSystem(ofType: EntityNodeFactorySystem.self)?.createEntity(type, point, size, subContent)
    }
}
