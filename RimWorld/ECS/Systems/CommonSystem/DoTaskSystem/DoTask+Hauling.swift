//
//  DoTask+Hauling.swift
//  RimWorld
//
//  Created by wu on 2025/7/7.
//

import Foundation

extension DoTaskSystem {
    
    /// 强制停止搬运任务
    func cancelHaulingAction(entity: RMEntity,
                               task: WorkTask) {
        
    }
    
    /// 设置搬运任务
    func setHaulingAction(entity: RMEntity,
                          task: WorkTask) {
        
        guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
            ECSLogger.log("执行的被搬运的目标没有了！💀💀💀")
            return
        }
        
        guard let saveEntity = ecsManager.getEntity(task.targetEntityID2) else {
            ECSLogger.log("执行的搬运的存储目标没有了！💀💀💀")
            return
        }
        
   
        /// 先走到搬运目标
        if task.haulStage == .movingToItem {
            task.haulStage = .movingToTarget
          
            /// 走到目的地，计算搬运人当前负重
            let capacity = EntityInfoTool.remainingCarryCapacity(entity)
            
            /// 当前物品单个重量
            let singleWeight = EntityInfoTool.haulingWeight(targetEntity)
            
            /// 当前物品数量
            let haulCount = EntityInfoTool.haulingCount(targetEntity)
            
            /// 需要新生成一个未全部搬运的实体
            if singleWeight * Double(haulCount) > capacity {
                
                let carryCount = Int(capacity / singleWeight)
                let lastCount = haulCount - carryCount
                
                RMEventBus.shared.requestCreateEntity(PositionTool.nowPosition(targetEntity), targetEntity.type,subContent: ["haulCount":lastCount])
                EntityActionTool.setHaulingCount(entity: targetEntity, count: carryCount)
                EntityNodeTool.updateHaulCountLabel(entity: targetEntity, count: carryCount)
            }
            
      
            
            /// 重新设置从属关系
            OwnerShipTool.handleOwnershipChange(owner: entity, owned: targetEntity, ecsManager: ecsManager)
            /// 更换父视图
            RMEventBus.shared.requestReparentEntity(entity: targetEntity, z: 100, point: CGPoint(x: 0, y: 0))
            
                        
            let startPoint = PositionTool.nowPosition(entity)

            /// 具体对应的格位置
            let saveSizePoint = PositionTool.saveAreaEmptyPosition(saveArea: saveEntity)
            let savePoint = PositionTool.nowPosition(saveEntity)
            let endPoint = CGPoint(x: savePoint.x + saveSizePoint.x, y: savePoint.y + saveSizePoint.y)
            
            
            RMEventBus.shared.requestFindingPath(entity: entity, startPoint: startPoint, endPoint: endPoint, task: task)
            
            
        }else if task.haulStage == .movingToTarget {
            
            /// 处理存储关系
            OwnerShipTool.handleOwnershipChange(owner: saveEntity,
                                                owned: targetEntity,
                                                ecsManager: ecsManager)
            /// 完成任务
            EntityActionTool.completeTaskAction(entity: entity, task: task)
        }
        
    }
    
}
