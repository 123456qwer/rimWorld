//
//  NodeBuilder+Tree.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import SpriteKit

extension NodeBuilder {
    
    /// 创建树
    func buildTree(_ entity:RMEntity) -> RMBaseNode {
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let treeComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self) {
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(treeComponent.plantTexture), color: .black, size: CGSize(width: tileSize * 2.0, height: tileSize * 2.0))
            node.name = "tree"
            node.position = CGPoint(x: pointComponent.x, y: pointComponent.y)
            node.zPosition = pointComponent.z
            
            /// 是否可以砍伐
            if treeComponent.canChop {
                let axe = SKSpriteNode(texture: TextureManager.shared.getTexture("chopIcon"),color: .black,size: CGSize(width: tileSize * 2.0, height: tileSize * 2.0))
                axe.name = "axeChop"
                axe.zPosition = 5
                node.addChild(axe)
            }
            
            return node
        }
        
        return RMBaseNode()
    }
    
    /// 树桩
    func buildWood(_ entity:RMEntity) -> RMBaseNode {
        
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let woodComponent = entity.getComponent(ofType: WoodBasicInfoComponent.self),
            let haulComponent = entity.getComponent(ofType: HaulableComponent.self) {
            
            /// 750 750
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(woodComponent.woodTexture), color: .black, size: CGSize(width: tileSize, height: tileSize))
            node.name = "tree"
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
}
