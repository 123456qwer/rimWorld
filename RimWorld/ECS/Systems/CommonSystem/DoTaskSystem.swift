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
    var cuttingTasks  :[Int : WorkTask] = [:]
    var restingTasks  :[Int : WorkTask] = [:]
    var buildingTasks :[Int : WorkTask] = [:]
    var sleepingTasks :[Int : WorkTask] = [:]
//    var growingTasks :[Int : WorkTask] = [:]


    
    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
  
    
    let ecsManager: ECSManager
    let provider: PathfindingProvider

    init (ecsManager: ECSManager,
          provider: PathfindingProvider) {
        self.ecsManager = ecsManager
        self.provider = provider
    }
    
    
    /// 按tick更新
    func actionUpdate(currentTick: Int) {
        
        let elapsedTicks = currentTick - lastProcessedTick
        lastProcessedTick = currentTick
     
        /// 休息
        for (executorEntityID, workTask) in restingTasks {
            executeRestingAction(executorEntityID: executorEntityID,
                                 task: workTask,
                                 tick: elapsedTicks)
        }
        
        /// 睡觉
        for (executorEntityID, workTask) in sleepingTasks {
            executeSleepingAction(executorEntityID: executorEntityID,
                                  task: workTask,
                                  tick: elapsedTicks)
        }
        
        /// 建造
        for (executorEntityID, workTask) in buildingTasks {
            executeBuildingAction(executorEntityID: executorEntityID,
                                  task: workTask,
                                  tick: elapsedTicks)
        }
        
        /// 砍伐
        for (executorEntityID, workTask) in cuttingTasks {
            executeCuttingAction(executorEntityID: executorEntityID,
                                 task: workTask,
                                 tick: elapsedTicks)
        }
        
       
        
    
    }


    
    /// 强制结束任务
    func forceSwitchTask(_ entity: RMEntity,
                         _ task: WorkTask) {
        
      
        
        switch task.type {
            
        case .Cutting:
            self.cancelCuttingAction(entity: entity,task: task)
        case .Hauling:
            self.cancelHaulingAction(entity: entity,task: task)
        case .Building:
            self.cancelBuildingAction(entity: entity, task: task)
        case .Growing:
            self.cancelGrowingAction(entity: entity, task: task)
        default:
            print("默认方法")
        }
        
        
        switch task.hightType {
        case .Eat:
            break
        case .Sleep:
            break
        case .Relax:
            break
        case .None:
            break
        }
    }
    
    /// 移动结束
    func moveEnd(entity: RMEntity,
                         task: WorkTask) {
  
        if task.isCancel {
            ECSLogger.log("做任务系统出问题了 \(entity.name) 💀💀💀 ")
            return
        }
        
        switch task.type {
            
        case .Cutting:
            setCuttingAction(entity: entity, task: task)
        case .Rest:
            setRestingAction(entity: entity, task: task)
        case .Hauling:
            setHaulingAction(entity: entity, task: task)
        case .Building:
            setBuildingAction(entity: entity, task: task)
        case .Growing:
            setGrowingAction(entity: entity, task: task)
            
        default:
            break
        }
        
        
        switch task.hightType {
        case .Eat:
            break
        case .Sleep:
            setSleepingAction(entity: entity, task: task)
        case .Relax:
            break
        case .None:
            break
        }
    }
    
}







