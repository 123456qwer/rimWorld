//
//  EntityFactory+Wall.swift
//  RimWorld
//
//  Created by wu on 2025/7/25.
//

import Foundation

extension EntityFactory {
    
    /// 创建墙
    func createWall(point: CGPoint,
                    params: WallParams) -> RMEntity {
        
        let wall = RMEntity()
        wall.type = params.type
        
        let wallComponent = WallComponent()
        wallComponent.textureName = params.wallTexture
        
        switch params.material {
        case .wood:
            wallComponent.totalHealth = 200
        default:
            break
        }
        
        wallComponent.currentHealth = wallComponent.totalHealth
        
        
        let positionComponent = PositionComponent()
        positionComponent.x = point.x
        positionComponent.y = point.y
        
        wall.addComponent(wallComponent)
        wall.addComponent(positionComponent)
        
        return wall
    }
    
}
