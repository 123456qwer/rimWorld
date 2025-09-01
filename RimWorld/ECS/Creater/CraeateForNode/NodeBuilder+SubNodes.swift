//
//  NodeBuilder+SubNodes.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 标记型Node
extension NodeBuilder {
    
    
    func ax(_ entity:RMEntity) -> RMBaseNode{
        /// 是否可以砍伐
        let axe = RMBaseNode(texture: TextureManager.shared.getTexture("chopIcon"),color: .black,size: CGSize(width: tileSize * 2.0, height: tileSize * 2.0))
        axe.name = "cutting"
        axe.zPosition = 5
        return axe
    }
    
    func pickaxe(_ entity:RMEntity) -> RMBaseNode{
        /// 是否可以砍伐
        let axe = RMBaseNode(texture: TextureManager.shared.getTexture("chopIcon"),color: .black,size: CGSize(width: tileSize * 2.0, height: tileSize * 2.0))
        axe.name = "mine"
        axe.zPosition = 5
        return axe
    }
    
    func pickHand(_ entity:RMEntity) -> RMBaseNode{
        /// 是否可以采摘
        let hand = RMBaseNode(texture: TextureManager.shared.getTexture("pickHand"),color: .black,size: CGSize(width: tileSize * 1.2, height: tileSize * 1.2))
        hand.name = "pickHand"
        hand.zPosition = 5
        return hand
    }
    
}
