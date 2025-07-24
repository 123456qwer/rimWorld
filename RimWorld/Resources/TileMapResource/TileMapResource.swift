//
//  TileMapResource.swift
//  RimWorld
//
//  Created by wu on 2025/5/30.
//

import Foundation

enum RMTileType {
    case land
    case river
    case ore
}

struct TileModel {
    var type: RMTileType
    var textureName: String
    var position: CGPoint
    var walkable: Bool
    var visible: Bool
}
