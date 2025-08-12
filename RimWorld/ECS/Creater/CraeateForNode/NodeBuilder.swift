//
//  NodeBuilder.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import SpriteKit

final class NodeBuilder: NSObject {
    
    /// 方法映射表
    lazy var selMap:[String: (RMEntity) -> RMBaseNode] = [
        
        /// 角色
        kCharacter: buildCharacter,
        /// 武器
        kWeapon: buildWeapon,
        /// 树
        kTree:buildTree,
        /// 苹果树
        kAppleTree:appleTree,
        /// 木头
        kWood:buildWood,
        /// 存储区域
        kStorageArea:storage,
        /// 种植区域
        kGrowingArea:growing,
        /// 蓝图
        kBlueprint:blueprint,
        /// 木头墙
        kWoodWall:woodWall,
        /// 水稻
        kRice:rice,
        /// 石头
        kStone: stone,
        /// 斧头
        kAX:ax,
        /// 镐子
        kPickaxe:pickaxe,
        /// 手
        kPickHand:pickHand,
        /// 矿产
        kOre:ore,
    ]
    
    /// 根据类型创建Node
    func buildNode(for entity: RMEntity) -> RMBaseNode {
        return selMap[entity.type]?(entity) ?? RMBaseNode()
    }
 
}
