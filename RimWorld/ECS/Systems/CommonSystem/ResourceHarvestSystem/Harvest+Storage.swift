//
//  Harvest+Storage.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 仓库移除
extension ResourceHarvestSystem {
    
    func removeStorage(reason: StorageRemoveReason) {
        
        let targetEntity = reason.entity
        
        guard let storageComponent = targetEntity.getComponent(ofType: StorageInfoComponent.self) else { return }
        
        let allEntities = storageComponent.saveEntities
        let growPoint = PositionTool.nowPosition(targetEntity)
        let points = PositionTool.getAreaAllPoints(size: storageComponent.size)
        
        /// 将子视图坐标转换成父视图坐标
        for (index,cropID) in allEntities {
            let cropEntity = ecsManager.getEntity(cropID) ?? RMEntity()
            let cropPoint = points[index]
            let pointForScene = CGPoint(x: growPoint.x + cropPoint.x, y: growPoint.y + cropPoint.y)
            PositionTool.setPosition(entity:cropEntity, point: pointForScene)
            OwnerShipTool.removeOwner(owned: cropEntity, ecsManager: ecsManager)
            cropEntity.removeComponent(ofType: OwnedComponent.self)
            
            RMEventBus.shared.requestReparentEntity(entity: cropEntity, z: 0, point: pointForScene)
        }
    }
}
