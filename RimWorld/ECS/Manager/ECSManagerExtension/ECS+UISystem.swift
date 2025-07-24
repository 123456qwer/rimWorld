//
//  ECS+UISystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// UI系统
extension ECSManager {
    
    /// 点击实体
    func clickEntity(_ entity:RMEntity,_ nodes:[Any]){
        systemManager.getSystem(ofType: UISystem.self)?.clickEntity(entity, nodes)
    }
    
    /// 点击空白
    func removeAllInfoAction() {
        systemManager.getSystem(ofType: UISystem.self)?.removeAllInfoAction()
    }
}
