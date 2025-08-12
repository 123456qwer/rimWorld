//
//  EntityFactory+tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
extension EntityFactory {
    
    /// 树
    func tree (point:CGPoint)
    {
        let entity = RMEntity()
        entity.type = kTree
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["tree1","tree2","tree3"].randomElement()!
        treeComponent.plantTexture = treeName
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        
        saveEntity(entity: entity)
    }
    
    
    func appleTree (point: CGPoint) {
        
        let entity = RMEntity()
        entity.type = kAppleTree
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["tree1","tree2","tree3"].randomElement()!
        treeComponent.plantTexture = treeName
        
        let foodComponent = FoodInfoComponent()
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        treeComponent.growthPercent = Float.random(in: 15...65)
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)
        entity.addComponent(foodComponent)
        /// 成熟度高于25，生成苹果
        if treeComponent.growthPercent > 50 {
            apple(superEntity: entity)
        }
        
        treeComponent.growthPercent = treeComponent.growthPercent / 100.0

        saveEntity(entity: entity)
    }
    
    /// 挂在树上的苹果
    func apple (superEntity: RMEntity){
        let entity = RMEntity()
        entity.type = kApple
        
             
        let woodComponent = GoodsBasicInfoComponent()
        let woodName = "apple"
        woodComponent.textureName = woodName
        
       
        let pointComponent = PositionComponent()
        pointComponent.x = Double.random(in: -15...15)
        pointComponent.y = Double.random(in: -15...15)
        pointComponent.z = maxZpoint - pointComponent.y
        
       
        
        entity.addComponent(pointComponent)
        entity.addComponent(woodComponent)

        /// 设置依赖
        OwnerShipTool.handleOwnershipChange(newOwner: superEntity, owned: entity, ecsManager: ECSManager())
        
        
        saveEntity(entity: entity)
    }
    
    
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
