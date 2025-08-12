//
//  NodeBuilder+Food.swift
//  RimWorld
//
//  Created by wu on 2025/8/12.
//

import Foundation
import SpriteKit
extension NodeBuilder {
    
    
    func apple(_ entity: RMEntity) -> RMBaseNode{
        
        if let goodsComponent = entity.getComponent(ofType: GoodsBasicInfoComponent.self),
           let pointComponent = entity.getComponent(ofType: PositionComponent.self),
           let haulComponent = entity.getComponent(ofType: HaulableComponent.self) {
            
            /// 750 750
            let node = RMBaseNode(texture: TextureManager.shared.getTexture(goodsComponent.textureName), color: .black, size: CGSize(width: tileSize, height: tileSize))
            node.name = kApple
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
