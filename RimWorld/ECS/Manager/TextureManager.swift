//
//  TextureManager.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import SpriteKit

class TextureManager: NSObject {
    
    public static let shared = TextureManager()

    var textures:[String: SKTexture] = [:]
    
    func getTexture(_ textureName: String) -> SKTexture {
        if let texture = textures[textureName] {
            return texture
        } else {
            let texture = SKTexture(imageNamed: textureName)
            textures[textureName] = texture
            return texture
        }
    }

}
