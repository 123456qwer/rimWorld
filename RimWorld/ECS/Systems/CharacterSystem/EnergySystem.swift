//
//  EnergySystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import SpriteKit
import Combine

class EnergySystem: System {
    
    var cancellables = Set<AnyCancellable>()
    
    /// 角色
    var characters:[RMEntity] = []
    
    /// 休息中的角色
    var restEntities:[Int : RMEntity] = [:]
    /// 非休息中的橘色
    var unRestEntities:[Int: RMEntity] = [:]
    
    /// 记录上次处理的tick
    var lastProcessedTick: Int = 0
    
    let ecsManager: ECSManager
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    
    func setupEnergy(){
        for entity in ecsManager.allEntities() {
            if entity.type == kCharacter {
                characters.append(entity)
            }
            
            /// 能量组件
            guard let energyComponent = entity.getComponent(ofType: EnergyComponent.self) else {
                continue
            }
            
            if energyComponent.isResting {
                restEntities[entity.entityID] = entity
            }else{
                unRestEntities[entity.entityID] = entity
            }
       
        }
    }
    
    /// 每帧更新
    func energyUpdate(currentTick: Int) {
        
        var elapsedTicks = currentTick - lastProcessedTick
        /// 首次进入
        if lastProcessedTick == 0 {
            elapsedTicks = 0
        }
        lastProcessedTick = currentTick
        
        /// 休息中的实体
        for (_ , value) in restEntities {
            guard let energyComponent = value.getComponent(ofType: EnergyComponent.self) else { continue }
            let speed = energyComponent.restRestorePerTick * Double(elapsedTicks)
            energyComponent.current += speed
            if energyComponent.current >= energyComponent.total {
                energyComponent.current = energyComponent.total
            }
        }
         
        
        /// 非休息中的实体
        for (_ , value) in unRestEntities {
            guard let energyComponent = value.getComponent(ofType: EnergyComponent.self) else { continue }
            guard let workComponent = value.getComponent(ofType: WorkPriorityComponent.self) else { continue }
            
            /// 每tick减少休息值
//            let speed = energyComponent.restDecayPerTick * Double(elapsedTicks)
            let speed = 0.001 * Double(elapsedTicks)
            energyComponent.current -= speed
            if energyComponent.current <= 0 {
                energyComponent.current = 0
            }

            /// 临界值
            let threshold: Double = {
                switch workComponent.rest {
                case 3: return energyComponent.threshold3
                case 2: return energyComponent.threshold2
                case 1: return energyComponent.threshold1
                default: return 0.0
                }
            }()
            
            
            if energyComponent.current <= 0 {
                /// 0，必须休息，让TaskSystem处理对应的任务
                if energyComponent.zeroSend { continue }
                energyComponent.zeroSend = true
                
                /// 休息任务
                RMEventBus.shared.requestRestTask(entity: value, mustRest: true)
                
            }else if energyComponent.current <= threshold {

                /// 小于临界值，发布休息任务，让TaskSystem处理对应的任务
                if energyComponent.alreadySend { continue }
                energyComponent.alreadySend = true
                
                /// 休息任务
                RMEventBus.shared.requestRestTask(entity: value, mustRest: false)
            }
        }
        
    }
 
    
    /// 修改休息状态
    func restStatusAction(entity: RMEntity, isRest: Bool){
        if isRest {
            unRestEntities.removeValue(forKey: entity.entityID)
            restEntities[entity.entityID] = entity
        }else {
            restEntities.removeValue(forKey: entity.entityID)
            unRestEntities[entity.entityID] = entity
        }
    }
    
}
