//
//  NodeBuilder+Tree.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import SpriteKit

/// Plant
extension NodeBuilder {
    
    /// 树
    func buildTree(_ entity:RMEntity) -> RMBaseNode {
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let treeComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self) {
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(treeComponent.plantTexture), color: .black, size: CGSize(width: tileSize * 2.0, height: tileSize * 2.0))
            node.name = "tree"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            
            return node
        }
        
        return RMBaseNode()
    }
    
    /// 苹果树
    func appleTree(_ entity: RMEntity) -> RMBaseNode {
        
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let treeComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self) {
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(treeComponent.plantTexture), color: .black, size: CGSize(width:tileSize * 2.0, height: tileSize * 2.0))
            node.name = "appleTree"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
   
            
            return node
        }
        
        return RMBaseNode()
    }
    
    /// 木材
    func buildWood(_ entity:RMEntity) -> RMBaseNode {
        
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let woodComponent = entity.getComponent(ofType: GoodsBasicInfoComponent.self),
            let haulComponent = entity.getComponent(ofType: HaulableComponent.self) {
            
            
            
            /// 750 750
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(woodComponent.textureName), color: .black, size: CGSize(width: tileSize, height: tileSize))
            node.name = "wood"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            
            let label = SKLabelNode(fontNamed: "Arial")
            label.fontColor = UIColor.ml_color(hexValue: 0xFFFFFF)
            label.zPosition = 100
            label.fontSize = 20
            label.numberOfLines = 0
            label.position = CGPoint(x: 0, y: -20.0)
            label.text = "\(haulComponent.currentCount)"
            label.name = "haulCount"
            node.addChild(label)
                     
            return node
        }
        
        return RMBaseNode()
    }
    
    /// 水稻
    func rice (_ entity: RMEntity) -> RMBaseNode {
        
        if let plantComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self), let pointComponent = entity.getComponent(ofType: PositionComponent.self) {
            
            /// 750 750
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(plantComponent.plantTexture), color: .black, size: CGSize(width: tileSize, height: tileSize))
            node.name = "plant"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            
            return node
        }
        
        
        return RMBaseNode()
    }
}

/// 石头
extension NodeBuilder {
    
    func stone(_ entity: RMEntity) -> RMBaseNode {
        
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let miningComponent = entity.getComponent(ofType: MiningComponent.self) {
            
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(miningComponent.miningTexture), color: .black, size: CGSize(width: tileSize, height: tileSize))
            node.name = "stone"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = 10
            
            return node
        }
        
        return RMBaseNode()
    }
    
}
