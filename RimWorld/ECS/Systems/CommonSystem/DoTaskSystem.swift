//
//  ActionAnimationSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation

import Combine

class DoTaskSystem: System {
    

    var cancellables = Set<AnyCancellable>()
    
   
    ///  KEY：执行人entityID
    var cuttingTasks:[Int : WorkTask] = [:]
    var restingTasks:[Int : WorkTask] = [:]
    
    /// 休息,key是休息人id,value是休息人
    var rests:[Int : RMEntity] = [:]

    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
  
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    
    /// 按tick更新
    func actionUpdate(currentTick: Int) {
        
        let elapsedTicks = currentTick - lastProcessedTick
        lastProcessedTick = currentTick
     
        /// 砍伐
        for (executorEntityID, workTask) in cuttingTasks {
            cuttingAction(executorID: executorEntityID,
                          task: workTask,
                          tick: elapsedTicks)
        }
        
        /// 休息
        for (executorEntityID, workTsk) in restingTasks {
            restAction(entityID: executorEntityID, task: workTsk, tick: elapsedTicks)
        }
        
      
    }


    
    /// 强制结束任务
    func forceSwitchTask(_ entity: RMEntity,
                         _ task: WorkTask) {
        switch task.type {
            
        case .Cutting:
            self.cancelCuttingAction(entity: entity,
                                  task: task)
        case .Hauling:
            self.cancelHaulingAction(entity: entity,
                                  task: task)
            
        default:
            print("默认方法")
        }
    }
    
    /// 移动结束
    func moveEnd(entity: RMEntity,
                         task: WorkTask) {
  
        
        switch task.type {
            
        case .Cutting:
            cuttingTasks[entity.entityID] = task
            
        case .Rest:
            EntityActionTool.startRest(entity: entity)
            restingTasks[entity.entityID] = task
            
        case .Hauling:
            setHaulingAction(entity: entity, task: task)
            
        default:
            break
        }
    }
    
}







