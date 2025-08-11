//
//  RMEventBus.swift
//  RimWorld
//
//  Created by wu on 2025/6/4.
//

import Foundation
import Combine
import SpriteKit

/// 事件中心
enum GameEvent {
    
    /// 点击暂停
    case pause
    case speed1
    case speed2
    case speed3
    
    // MARK: - InfoView相关操作
    /// 点击实体
    case didSelectEntity(entity:RMEntity,nodes:[Any])
    /// 点击空白
    case clickEmpty
    /// 刷新所有系统
    case updateAllSystem(entitys: [RMEntity],
                         entityMap: [Int : RMBaseNode])

    /// 关闭游戏时，删除一些进行时中的依赖关系（比如携带了树木）
    case terminateForRemoveTaskOwner
    
    
    // MARK: - 对实体的增删改查 -
    /// 删除实体
    case removeEntity(entity: RMEntity,
                      reason: RemoveReason?)
    /// 创建实体
    case createEntity(type: String,
                      point: CGPoint,
                      param: EntityCreationParams)
    /// 添加实体
    case addEntity(entity: RMEntity)
    /// 修改实体归属
    case reparentEntity(entity:RMEntity,
                        z:CGFloat,
                        point:CGPoint)
    /// 修改存储实体
    case changeStorage(entity:RMEntity)
    /// 修改角色优先级
    case updatePriorityEntity(entity: RMEntity,
                              workType: WorkType)
    

    
    // MARK: - 任务系统通用事件 -
    /// 去做任务
    case doTask(entityID: Int, task: WorkTask)
    /// 完成任务
    case completeTask(entityID: Int, task: WorkTask)
    /// 切换任务，停止之前的寻路
    case forceCancelTask(entity: RMEntity, task: WorkTask)
    /// 寻路事件
    case findingPath(entity: RMEntity,
                     startPoint:CGPoint,
                     endPoint:CGPoint,
                     task:WorkTask)
    /// 移动事件
    case move(points:[CGPoint], entity: RMEntity, task: WorkTask)
    /// 移动停止（比如终止任务等）
    case moveStop(entity: RMEntity)
    /// 移动结束事件（完成移动）
    case moveEnd(entity: RMEntity,
                 task: WorkTask)
    /// 重置此类型的搬运任务
    case reloadHaulingTasks(materialType:MaterialType)
    /// 将实体从可搬运列表里移除
    case removeFromHaulCategory(entity: RMEntity)
    
    
    
    
    // MARK: - 玩家可控制等级的任务 -
    /// 休息任务
    case restTask(entity: RMEntity, mustRest: Bool)
    /// 建造任务
    case buildingTask(entity: RMEntity)
    /// 砍伐任务
    case cuttingTask(entity:RMEntity, canChop:Bool)
    /// 采摘任务
    case pickTask(entity: RMEntity, canPick:Bool)
    /// 搬运任务
    case haulingTask(entity: RMEntity)
    
    
    // MARK: - UIView 操作 -
    case clickBottomButton(btnType: ButtonType)
    
    
    
    // MARK: - 玩家不可控任务 -
    /// 睡觉
    case sleepTask(entity: RMEntity)
    /// 角色休息状态改变
    case restStatusChange(entity: RMEntity, isRest:Bool)
    /// 吃饭
    case eatTask(entity: RMEntity)
    /// 娱乐
    case relaxTask(entity: RMEntity)

}

/// 事件总线
final class RMEventBus {
    
    static let shared = RMEventBus()
    
    private var listeners: [(GameEvent) -> Void] = []
    private let subject = PassthroughSubject<GameEvent, Never>()
        
    private init () {}
    
    
    /// 同步发布事件：立即触发所有监听器
    func publish(_ event: GameEvent) {
        for listener in listeners {
            listener(event)
        }
    }
    
    /// 添加一个监听器（同步）
    func subscribe(_ listener: @escaping (GameEvent) -> Void) {
        listeners.append(listener)
    }
    
//    func publish(_ event: GameEvent) {
//        subject.send(event)
//    }
    
//    func publisher() -> AnyPublisher<GameEvent, Never> {
//        subject.eraseToAnyPublisher()
//    }
}



/// 实体的增删改查任务
extension RMEventBus {
    /// 删除实体
    func requestRemoveEntity(_ entity: RMEntity, reason: RemoveReason? = nil) {
        self.publish(.removeEntity(entity: entity, reason: reason))
    }
    
    /// 创建实体
    func requestCreateEntity(type: String,
                             point: CGPoint,
                             params: EntityCreationParams) {
        self.publish(.createEntity(type: type, point: point, param: params))
    }
    
    /// 添加实体（游戏过程中，这个调用，总是在创建实体之后）
    func requestAddEntity(_ entity: RMEntity) {
        self.publish(.addEntity(entity: entity))
    }
    
    /// 修改实体任务优先级
    func requestChangePriorityEntity(entity: RMEntity,
                                     workType:WorkType) {
        self.publish(.updatePriorityEntity(entity: entity,
                                           workType: workType))
    }

    /// 修改实体父类
    func requestReparentEntity(entity:RMEntity,
                               z:CGFloat,
                               point:CGPoint) {
        self.publish(.reparentEntity(entity: entity,z: z,point: point))
    }
    
    /// 修改存储实体
    func requestChangeSaveAreaEntity(entity: RMEntity) {
        self.publish(.changeStorage(entity: entity))
    }
    
    /// 实体放入到了蓝图中，需要修改其状态，不能再次搬运了
    func requestRemoveFromHaulCategory(entity: RMEntity) {
        self.publish(.removeFromHaulCategory(entity: entity))
    }
    
}

/// 优先级任务（休息、搬运、研究等）
extension RMEventBus {
    /// 休息任务（并非Sleep,而是受伤后，主动修养）
    func requestRestTask(entity: RMEntity, mustRest: Bool) {
        self.publish(.restTask(entity: entity, mustRest: mustRest))
    }
    /// 砍树任务
    func requestCuttingTask(entity: RMEntity, canChop: Bool) {
        self.publish(.cuttingTask(entity: entity, canChop: canChop))
    }
    func requestPickingTask(entity: RMEntity, canPick: Bool) {
        self.publish(.pickTask(entity: entity, canPick: canPick))
    }
    /// 搬运任务
    func requestHaulTask(_ entity: RMEntity) {
        self.publish(.haulingTask(entity: entity))
    }
    /// 建造任务
    func requestBuildTask (_ entity: RMEntity) {
        self.publish(.buildingTask(entity: entity))
    }
}

/// 高优先级任务（吃饭，睡觉，娱乐）
extension RMEventBus {
    /// 睡觉任务
    func requestSleepTask(entity: RMEntity) {
        self.publish(.sleepTask(entity: entity))
    }
    /// 吃饭任务
    func requestEatTask(entity: RMEntity) {
        self.publish(.eatTask(entity: entity))
    }
    /// 娱乐任务
    func requestRelaxTask(entity: RMEntity) {
        self.publish(.relaxTask(entity: entity))
    }
}


/// 玩家实际操控的任务
extension RMEventBus {
    
    /// 点击实体
    func requestClickEntity(_ entity: RMEntity, _ nodes: [Any]) {
        self.publish(.didSelectEntity(entity: entity, nodes: nodes))
    }
    /// 点击空白处
    func requestClickEmpty() {
        self.publish(.clickEmpty)
    }
    
    /// 点击底部UI按钮
    func requestClickBottomButton(buttonType: ButtonType) {
        self.publish(.clickBottomButton(btnType: buttonType))
    }
}

/// 通用任务
extension RMEventBus {
    
    /// 寻路
    func requestFindingPath(entity: RMEntity,
                            startPoint:CGPoint,
                            endPoint:CGPoint,
                            task:WorkTask) {
        self.publish(.findingPath(entity: entity,
                                  startPoint: startPoint,
                                  endPoint: endPoint,
                                  task: task))
    }
    
    /// 强制取消任务
    func requestForceCancelTask(entity: RMEntity,task: WorkTask) {
        self.publish(.forceCancelTask(entity: entity, task: task))
    }
    
    /// 移动任务
    func requestMoveTask(points:[CGPoint], entity: RMEntity, task: WorkTask) {
        self.publish(.move(points: points, entity: entity, task: task))
    }
    
    /// 移动结束
    func requestMoveEndTask(entity: RMEntity, task: WorkTask){
        self.publish(.moveEnd(entity: entity, task: task))
    }
    
    /// 根据类型重置搬运任务
    func requestReloadHaulingTasks(material: MaterialType){
        self.publish(.reloadHaulingTasks(materialType: material))
    }
    
    /// 退出游戏，删除依赖
    func requestTerminateForRemoveTaskOwner() {
        self.publish(.terminateForRemoveTaskOwner)
    }
}
