//
//  DoTask+Eat.swift
//  RimWorld
//
//  Created by wu on 2025/8/13.
//

import Foundation
extension DoTaskSystem {
    
    
    func setEatAction(entity: RMEntity,
                      task: WorkTask){
        executeEatAction(executor: entity, task: task, tick: 1)
    }
    
    
    /// 执行吃饭
    func executeEatAction(executor: RMEntity,
                              task: WorkTask,
                              tick: Int){
  
        guard let food = ecsManager.getEntity(task.eatTask.targetID) else {
            ECSLogger.log("吃的没了！ 💀💀💀")
            return
        }
        
        
        if task.eatTask.eatStage == .movingToItem {
            
            task.eatTask.eatStage = .movingToTarget
            
            /// 搬运物是否在存储区域
            let isInStorage = EntityInfoTool.isInStorage(entity: food, ecsManager: ecsManager)
            
            let allCount = EntityInfoTool.haulingCount(food)
            
            var needCount = 5

            if food.type == kApple {
                needCount = 5
            }
            
            /// 饱食度，总量/需求量
            task.eatTask.restorePercent = min(CGFloat(allCount) / CGFloat(needCount),1.0)
        
            
            needCount = min(needCount, allCount)
            
            // 剩余
            let lastCount = allCount - needCount
            
            if isInStorage {
                /// 从仓库中拿
                haulingFromStorage(lastCount: lastCount, actualHaul: needCount, material: food)
                
            }else {
                /// 如果有剩余，生成新的素材
                haulingFromLand(lastCount: lastCount, actualHaul: needCount, material: food)
            }
            
            
            /// 重新设置从属关系
            OwnerShipTool.handleOwnershipChange(newOwner: executor, owned: food, ecsManager: ecsManager)
            /// 更换父视图
            RMEventBus.shared.requestReparentEntity(entity: food, z: 100, point: CGPoint(x: 0, y: 0))
            
            
            let endPoint = CGPoint(x: 0, y: 0)
            let startPoint = PositionTool.nowPosition(executor)
            
            RMEventBus.shared.requestFindingPath(entity: executor, startPoint: startPoint, endPoint: endPoint, task: task)
            
        } else {
            
            executor.node?.eatAnimation {[weak self] in
                
                guard let self = self else {return}
                self.finishEat(executor: executor,
                               task:task)
            }
        }
        
       
     
    }
    
    /// 结束吃饭命令  restorePercent:饱食度
    func finishEat(executor: RMEntity ,
                   task: WorkTask){
        
        /// 恢复饱食度
        EntityActionTool.restoreHungerAfterEating(entity: executor,task: task)
        
        /// 完成任务
        EntityActionTool.completeTaskAction(entity: executor, task: task)
        
        
        guard let food = ecsManager.getEntity(task.eatTask.targetID) else {
            return
        }
        
        /// 移除食物
        RMEventBus.shared.requestRemoveEntity(food)
        
    }
}
