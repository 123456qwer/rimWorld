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
    func chopStatusChange(_ entity: RMEntity,
                          canChop: Bool) {
        /// 可以砍伐，生成斧子node,不可以，删除斧子Node
        if canChop {
            /// 添加斧子
            let params = AXParams(ownerId: entity.entityID)
            RMEventBus.shared.requestCreateEntity(type: kAX, point: CGPoint(x: 0, y: 0), params: params)
        }else {
            /// 移除斧子
            if let ax = EntityInfoTool.getAX(targetEntity: entity, ecsManager: self){
                RMEventBus.shared.requestRemoveEntity(ax)
            }
        }
    }
    
    /// 修改采摘状态
    func pickStatusChange(_ entity: RMEntity,
                          canPick: Bool) {
        /// 可以采摘，生成手node,不可以，删除手Node
        if canPick {
            /// 添加手
            let params = HandParams(ownerId: entity.entityID)
            RMEventBus.shared.requestCreateEntity(type: kPickHand, point: CGPoint(x: 0, y: 0), params: params)
        }else {
            /// 移除手
            if let hand = EntityInfoTool.getHand(targetEntity: entity, ecsManager: self){
                RMEventBus.shared.requestRemoveEntity(hand)
            }
        }
    }
    
    
    /// 修改采矿状态
    func mineStatusChange(_ entity: RMEntity,
                          canMine: Bool) {
        /// 可以挖掘，生成node,不可以，删除Node
        if canMine {
            /// 添加镐子
            let params = MineParams(ownerId: entity.entityID)
            RMEventBus.shared.requestCreateEntity(type: kPickaxe, point: CGPoint(x: 0, y: 0), params: params)
        }else {
            /// 移除镐子
            if let hand = EntityInfoTool.getMine(targetEntity: entity, ecsManager: self){
                RMEventBus.shared.requestRemoveEntity(hand)
            }
        }
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
