//
//  EntityFactory+tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
extension EntityFactory {
    
    /// 水稻
    func createRice (point: CGPoint,
                     params: PlantParams,
                     ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kRice
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["apple"].randomElement()!
        treeComponent.plantTexture = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        let ownedComponent = OwnedComponent()
        ownedComponent.ownedEntityID = params.ownerId
        
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        entity.addComponent(ownedComponent)
        
        /// 设置在种植区域内
        let growArea = ecsManager.getEntity(params.ownerId)
        if let growComponent = growArea?.getComponent(ofType: GrowInfoComponent.self) {
            growComponent.saveEntities[params.saveKey] = entity.entityID
        }
        
        return entity
    }
    
}


/// 与植物相关的node（如斧头等）
extension EntityFactory {
    
    /// 砍伐的斧头
    func createAX(point: CGPoint,
                  params: AXParams,
                  ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kAX
        
        let ownedComponent = OwnedComponent()
        ownedComponent.ownedEntityID = params.ownerId
        
        let nonComponent = NonInteractiveComponent()
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        
        entity.addComponent(ownedComponent)
        entity.addComponent(pointComponent)
        entity.addComponent(nonComponent)
        
        
        /// 设置拥有者
        if let ownerEntity = ecsManager.getEntity(params.ownerId) {
            OwnerShipTool.handleOwnershipChange(newOwner: ownerEntity, owned: entity, ecsManager: ecsManager)
        }else{
            ECSLogger.log("砍伐的树木目标没了！💀💀💀")
        }
        
        return entity
    }
    
    
    /// 采摘的手
    func createHand(point: CGPoint,
                    params: HandParams,
                    ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kPickHand
        
        let ownedComponent = OwnedComponent()
        ownedComponent.ownedEntityID = params.ownerId
        
        let nonComponent = NonInteractiveComponent()
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        
        entity.addComponent(ownedComponent)
        entity.addComponent(pointComponent)
        entity.addComponent(nonComponent)
        
        
        /// 设置拥有者
        if let ownerEntity = ecsManager.getEntity(params.ownerId) {
            OwnerShipTool.handleOwnershipChange(newOwner: ownerEntity, owned: entity, ecsManager: ecsManager)
        }else{
            ECSLogger.log("砍伐的树木目标没了！💀💀💀")
        }
        
        return entity
    }
    
    
    /// 挖掘的镐
    func createMine(point: CGPoint,
                  params: MineParams,
                  ecsManager: ECSManager) -> RMEntity{
        
        let entity = RMEntity()
        entity.type = kPickaxe
        
        let ownedComponent = OwnedComponent()
        ownedComponent.ownedEntityID = params.ownerId
        
        let nonComponent = NonInteractiveComponent()
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        
        entity.addComponent(ownedComponent)
        entity.addComponent(pointComponent)
        entity.addComponent(nonComponent)
        
        
        /// 设置拥有者
        if let ownerEntity = ecsManager.getEntity(params.ownerId) {
            OwnerShipTool.handleOwnershipChange(newOwner: ownerEntity, owned: entity, ecsManager: ecsManager)
        }else{
            ECSLogger.log("挖掘的矿产目标没了！💀💀💀")
        }
        
        return entity
    }
    
}
