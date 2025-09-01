//
//  EntityFactory+BuildFurniture.swift
//  RimWorld
//
//  Created by wu on 2025/8/14.
//

import Foundation
/// 家具类
extension EntityFactory {
    
    /// 创建灶台
    func createStove(point: CGPoint,
                     params: StoveParams,
                    provider: PathfindingProvider) -> RMEntity {
        
        let stove = RMEntity()
        stove.type = params.type
        
        let blockComponent = MovementBlockerComponent()
        
        blockComponent.positions.append(point)
        let stoveComponent = StoveComponent()
        stoveComponent.textureName = params.wallTexture
        stoveComponent.width = params.width
        stoveComponent.height = params.height
        
        switch params.material {
        case .wood:
            stoveComponent.totalHealth = 200
        case .marble:
            stoveComponent.totalHealth = 300
        default:
            break
        }
        
        stoveComponent.currentHealth = stoveComponent.totalHealth
        
        
        let positionComponent = PositionComponent()
        positionComponent.x = point.x
        positionComponent.y = point.y
        
        
        let directionComponent = DirectionComponent()
        
        
        
        stove.addComponent(stoveComponent)
        stove.addComponent(positionComponent)
        stove.addComponent(blockComponent)
        stove.addComponent(directionComponent)

        
        let point = PositionTool.nowPosition(stove)
        provider.setWalkable(x: Int(point.x), y: Int(point.y), canWalk: false)
        
        return stove
    }
    
}
