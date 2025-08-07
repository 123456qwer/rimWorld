//
//  GameScene.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import SpriteKit
import GameplayKit
import Combine

class GameScene: BaseScene {
    

    var columns: Int { Int(size.width / tileSize) }
    var rows: Int { Int(size.height / tileSize) }

    var map: [[RMTileType]] = []
    

    
    var cancellables = Set<AnyCancellable>()
    
    
    


    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        
        RMEventBus.shared.subscribe {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .pause:
                self.isPaused = true
            case .speed1:
                self.isPaused = false
                self.rmTime.timeScale = 1.0
                print("游戏速度 1 倍")
            case .speed2:
                self.isHidden = false
                self.rmTime.timeScale = 2.0
                print("游戏速度 2 倍")
            case .speed3:
                self.isPaused = false
                self.rmTime.timeScale = 3.0
                print("游戏速度 3 倍")
            case .removeEntity(let entity,let reason):
                ECSLogger.log("删除实体：\(entity.name)")
                
            default:
                break 
            }
        }
        
    }
    
   
    
    

    
    func touchDown(atPoint pos : CGPoint) {
        inputSystem.touchDown(atPoint: pos, scene: self)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        inputSystem.touchMoved(toPoint: pos, scene: self)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        inputSystem.touchUp(atPoint: pos, scene: self, entities: ecsManager.allEntities())
    }
    
  

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if activeTouch != nil { return }
        
        for t in touches {
            activeTouch = t
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let activeTouch = activeTouch, touches.contains(activeTouch) else { return }
        
        for t in touches {
            if t == activeTouch {
                self.touchMoved(toPoint: t.location(in: self))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeTouch = nil
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
     
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
 
}
