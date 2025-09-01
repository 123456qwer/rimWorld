//
//  EntityFactory+InitEntity.swift
//  RimWorld
//
//  Created by wu on 2025/8/13.
//

import Foundation

/// 首次进入，直接存入到数据库的实体
extension EntityFactory {
    
    /// 树
    func tree (point:CGPoint) {
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
    
    /// 苹果树
    func appleTree (point: CGPoint) {
        
        let entity = RMEntity()
        entity.type = kAppleTree
        
        let treeComponent = PlantBasicInfoComponent()
        let treeName = ["appleTree"].randomElement()!
        treeComponent.plantTexture = treeName
        treeComponent.haveHarvest = true
        
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        treeComponent.growthPercent = Float.random(in: 15...65)
        
        entity.addComponent(pointComponent)
        entity.addComponent(treeComponent)

        
        /// 成熟度高于25，生成苹果
        apple(superEntity: entity,save: true)
        
        
        treeComponent.growthPercent = treeComponent.growthPercent / 100.0

        saveEntity(entity: entity)
    }
    
    /// 挂在树上的苹果
    @discardableResult
    func apple (superEntity: RMEntity,
                save:Bool) -> RMEntity{
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
        
        if save {
            saveEntity(entity: entity)
        }
        
        return entity
    }
    
    /// 石头
    func stone(point: CGPoint) {
        
        let entity = RMEntity()
        entity.type = kStone
        
        let blockComponent = MovementBlockerComponent()
        let miningComponent = MiningComponent()
        miningComponent.miningTexture = "stone"
        
        let pointComponent = PositionComponent()
        pointComponent.x = point.x
        pointComponent.y = point.y
        pointComponent.z = maxZpoint - point.y
        
        blockComponent.positions.append(point)
        
        entity.addComponent(pointComponent)
        entity.addComponent(blockComponent)
        entity.addComponent(miningComponent)

        
        saveEntity(entity: entity)
    }
    
}
