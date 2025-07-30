//
//  ReloadTask.swift
//  RimWorld
//
//  Created by wu on 2025/7/30.
//

import Foundation

/// 重置任务
extension CharacterTaskSystem {
    
    /// 因为蓝图搬运过程中可能会改变对应数量，所以需要重置已经创建的任务
    func reloadHaulTaskWithMaterial(material: MaterialType) {
        
        allTaskQueue.removeAll { task in
            guard task.type == .Hauling,
                  let target = ecsManager.getEntity(task.targetEntityID),
                  let _ = target.getComponent(ofType: HaulableComponent.self),
                  let blueComponent = ecsManager.getEntity(task.targetEntityID)?.getComponent(ofType: BlueprintComponent.self) else {
                return false
            }
            
            let type = EntityInfoTool.materialType(target)
            /// 将之前预搬的置为0
            if type == material {
                blueComponent.alreadyCreateHaulTask[material]?[task.targetEntityID] = nil
            }
            
            
            return type == material
        }
        
        /// 新增任务
        let ableToBeHaul = ecsManager.entitiesAbleToBeHaul()
        for entity in ableToBeHaul {
            let type = EntityInfoTool.materialType(entity)
            if type == material {
                addHaulingTasks(targetEntity: entity)
            }
        }
        
    }

    
}
