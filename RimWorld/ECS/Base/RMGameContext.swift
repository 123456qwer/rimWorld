//
//  RMGameContext.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation
import Combine

class RMGameContext {
    
    var cancellables = Set<AnyCancellable>()

    var ecsManager:ECSManager!
    
    /// 当前的游戏模式（默认/建造/选择区域等）
    var currentMode: ActionType = .none
    
    
    func getAllEntities() -> [RMEntity] {
        return ecsManager.allEntities()
    }
    
    
  
}
