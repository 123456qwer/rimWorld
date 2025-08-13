//
//  Harvest+Plant.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 植物移除
extension ResourceHarvestSystem {
    
    ///
    func removePlant (params: TreeRemoveReason) {
        let targetEntity = params.entity
        /// 树坐标
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        /// 生成的木头量
        let woodCount = EntityInfoTool.currentHarvestAmountForPlant(entity: targetEntity)
        
        /// 生成树大于0，才产生新的木头
        if woodCount > 0 {
            
            let params = HarvestParams(
                harvestCount: woodCount
            )
            
            /// 创建木材实体（需要当前这个树来确定生成多少个木头）
            RMEventBus.shared.requestCreateEntity(type: kWood,
                                                  point: targetPoint,
                                                  params: params)
        }
        
        
        
        /// 是否可收获苹果果实
        let ableToHaverst = EntityAbilityTool.ableToHaverst(target: targetEntity)
        if ableToHaverst == true {
            if let apple = EntityInfoTool.getSubEntityWithType(targetEntity: targetEntity, ecsManager: ecsManager, type: kApple){
                let reason = PickRemoveReason(entity: apple)
                RMEventBus.shared.requestRemoveEntity(apple, reason: reason)
            }
        }
   
    }
    
    
    /// 移除苹果，生成新苹果
    func removeApple(params: PickRemoveReason){
        
        let appleEntity = params.entity
        
        guard let ownedComponent = appleEntity.getComponent(ofType: OwnedComponent.self), let treeEntity = ecsManager.getEntity(ownedComponent.ownedEntityID) else {
            return
        }
        
        
        let targetEntity = treeEntity
        /// 树坐标
        let targetPoint = PositionTool.nowPosition(targetEntity)
        let applePoint = MathUtils.getSurroundingPoints(center: targetPoint).randomElement()!
        
        /// 生
        let goodsCount = EntityInfoTool.currentHarvestAmountForPlant(entity: targetEntity)
        
        /// 生成树大于0，
        if goodsCount > 0 {
            
            let params = HarvestParams(
                harvestCount: goodsCount
            )
            
            /// 创建木材实体（需要当前这个树来确定生成多少个木头）
            RMEventBus.shared.requestCreateEntity(type: kApple,
                                                  point: applePoint,
                                                  params: params)
        }
     
    }
}
