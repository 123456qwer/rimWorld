//
//  TestScene.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import SpriteKit

class RMNode: Hashable {
    let x: Int
    let y: Int
    var gCost: Int = 0 /// 从起点到当前点的消耗
    var hCost: Int = 0 /// 启发式代价
    var parent: RMNode?
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    var fCost: Int {
        return gCost + hCost
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func == (lhs: RMNode, rhs: RMNode) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

