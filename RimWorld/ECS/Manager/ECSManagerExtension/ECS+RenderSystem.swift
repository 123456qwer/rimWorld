//
//  ECS+RenderSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/10.
//

import Foundation

/// 渲染系统
extension ECSManager {
    /// 修改砍伐状态
    func treeStatusChange(_ entity: RMEntity,
                          canChop: Bool) {
        systemManager.getSystem(ofType: RenderSystem.self)?.treeStatusChange(entity, canChop: canChop)
    }
    
    /// 修改父类
    func reparentNode(_ entity: RMEntity,
                      _ z: CGFloat,
                      _ point:CGPoint){
        systemManager.getSystem(ofType: RenderSystem.self)?.reparentNode(entity, z, point)
    }
    
    /// 重置数字
    func reloadNodeNumber(_ entity: RMEntity){
        systemManager.getSystem(ofType: RenderSystem.self)?.reloadNodeNumber(entity)
    }
    
    /// 渲染系统新增实体
    func renderAdd(entity: RMEntity) {
        /// RenderSystem渲染系统
        systemManager.getSystem(ofType: RenderSystem.self)?.addNode(entity)
    }
    
    /// 渲染系统删除实体
    func renderRemove(entity: RMEntity) {
        systemManager.getSystem(ofType:RenderSystem.self)?.removeNode(entity)
    }
}
