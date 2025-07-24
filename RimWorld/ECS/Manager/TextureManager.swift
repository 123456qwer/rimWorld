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
    
    func getTexture(_ textureName: String) -> SKTexture{
        
        var texture = textures[textureName]
        if texture == nil {
            let image = UIImage(named: textureName)
            texture = SKTexture(image: image ?? UIImage(named: "workPreference")!)
            textures[textureName] = texture
        }
        
        return texture ?? SKTexture(image: UIImage(named: "workPreference")!)
    }
}
