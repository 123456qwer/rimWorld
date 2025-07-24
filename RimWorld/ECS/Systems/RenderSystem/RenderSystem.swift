//
//  RenderSystem.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import Foundation
import Combine
import SpriteKit

final class RenderSystem: System {
  
    
    var cancellables = Set<AnyCancellable>()

    let renderContent: RenderContext
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager,
          renderContent: RenderContext) {
        
        self.ecsManager = ecsManager
        self.renderContent = renderContent
      
        for entity in ecsManager.allEntities() {
            addNode(entity)
        }
    }
    
    /// 添加Node
    func addNode(_ entity: RMEntity){
        
        /// 被持有的，直接添加到持有的实体上
        if let ownedComponent = entity.getComponent(ofType: OwnedComponent.self){
            self.renderContent.addNode(entity.node ?? RMBaseNode(), to: ownedComponent.ownedEntityID)
        }else{
            self.renderContent.addNode(entity.node ?? RMBaseNode(), to: -1)
        }
    }
    
    /// 移除Node
    func removeNode(_ entity: RMEntity) {
        entity.node?.removeFromParent()
    }
    
    func reparentNode(_ entity: RMEntity,
                      _ z: CGFloat,
                      _ point:CGPoint) {
        
        entity.node?.removeFromParent()
        entity.node?.zPosition = z
        
        /// 重置位置
        PositionTool.setPosition(entity: entity,
                                  point: point)

        if let ownedComponent = entity.getComponent(ofType: OwnedComponent.self){
            self.renderContent.addNode(entity.node ?? RMBaseNode(), to: ownedComponent.ownedEntityID)
        }else{
            self.renderContent.addNode(entity.node ?? RMBaseNode(), to: -1)
        }
    }

    
    /// 重置数字
    func reloadNodeNumber(_ entity: RMEntity) {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else { return }
        
        if let label = entity.node?.childNode(withName: "haulCount") as? SKLabelNode{
            label.text = "\(haulComponent.currentCount)"
        }
    }
   
}
