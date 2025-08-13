//
//  NodeManager.swift
//  RimWorld
//
//  Created by wu on 2025/8/13.
//

import Foundation

class NodeManager: NSObject {
    public static let shared = NodeManager()
    
    var nodes:[String:RMBaseNode] = [:]
    
    func getNodeWithType(type: String) -> RMBaseNode{
        let node = nodes[type] ?? RMBaseNode()
        nodes[type] = node
        return node
    }
}
