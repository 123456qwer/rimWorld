//
//  CharacterTaskSystem+Building.swift
//  RimWorld
//
//  Created by wu on 2025/6/10.
//

import Foundation

/// 建造
extension CharacterTaskSystem {
    
    func generateBuildingTask () {
        
    }
    
    
    @discardableResult
    func addBuildTask(_ entity: RMEntity) -> WorkTask{
        
        let task = WorkTask(type: .Building, targetEntityID: entity.entityID, executorEntityID: 0)
        taskQueue.append(task)
        sortTaskQueue()
        
        return task
    }
    
    
    func handleBuildTask(_ task: WorkTask) {
        
    }
}
