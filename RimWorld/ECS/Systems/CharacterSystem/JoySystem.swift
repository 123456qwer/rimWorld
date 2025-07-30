//
//  JoySystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import SpriteKit

class JoySystem: System {
    
    /// 角色
    var characters:[RMEntity] = []
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    func setupJoy(){
        /// 更新娱乐值
        NotificationCenter.default.addObserver(self, selector: #selector(updateJoyDrop), name: .RMGameTimeJoyTick, object: nil)
        for entity in ecsManager.allEntities() {
            if entity.type == kCharacter {
                characters.append(entity)
            }
        }
    }


    
    @objc func updateJoyDrop(_ notification:NSNotification) {

        for entity in characters {
            
            /// 更新角色实体饥饿值
            if let joyComponent = entity.getComponent(ofType: JoyComponent.self){
                joyComponent.current -= joyComponent.reduce
                /// 最小不小于0
                joyComponent.current = max(0, joyComponent.current)
                
                if joyComponent.current < joyComponent.threshold {
                    ECSLogger.log("娱乐值小于临界点，需要玩了！")
                }
                
            }
            
        }
    }
    

}
    
