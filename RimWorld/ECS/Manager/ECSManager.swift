//
//  ECSManager.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import Foundation
import Combine





class ECSManager {
    
    var entityManager: EntityManager
    var systemManager: SystemManager
    private var lastUpdateTime:TimeInterval = 0
    
    var cancellables = Set<AnyCancellable>()

    init() {
        
        self.entityManager = EntityManager()
        self.systemManager = SystemManager()
        
        RMEventBus.shared.subscribe {[weak self] event in
            
            guard let self = self else {return}
            
            switch event {
                /// 删除实体
            case .removeEntity(let entity):
                self.removeEntity(entity)
                
                /// 添加实体
            case .addEntity(let entity):
                self.addEntity(entity)
                
                /// 修改存储实体
            case .changeStorage(let entity):
                self.changeSaveAreaEntity(entity)
                
                /// 创建实体
            case .createEntity(let type,
                               let point,
                               let params):
                
                self.createEntity(type: type,
                                  point: point,
                                  params: params)
                
                /// 选中实体
            case .didSelectEntity(let entity,let nodes):
                self.clickEntity(entity,nodes)
                
                /// 点击空白处
            case .clickEmpty:
                self.removeAllInfoAction()
                
                /// 重置此类型搬运任务
            case .reloadHaulingTasks(let materialType):
                self.reloadHaulingTasks(materialType: materialType)
                
                /// 修改休息状态
            case .restStatusChange(let entity, let isRest):
                self.restStatusAction(entity: entity, isRest: isRest)
                
                /// 寻路
            case .findingPath(let entity, let startPoint, let endPoint, let task):
                self.startFind(entity: entity, start: startPoint, end: endPoint,task: task)
                
                /// 强制终止任务
            case .forceCancelTask(let entity, let task):
                self.forceSwitchTask(entity: entity, task: task)
                
                /// 移动结束
            case .moveEnd(let entity,let task):
                self.moveEnd(entity:entity,
                             task: task)
                
                /// 创建搬运任务
            case .haulingTask(let entity):
                self.addHaulingTask(entity)
                
                /// 创建砍伐任务
            case .cuttingTask(let entity, let canChop):
                self.addOrCancelCuttingTask(entity, canChop)

                /// 创建休息任务
            case .restTask(let entity, let isRest):
                self.addRestTask(entity, isRest)
               
                /// 创建建造任务
            case .buildingTask(let entity):
                self.addBuildTask(entity)
                
                /// 创建睡觉任务
            case .sleepTask(let entity):
                self.addSleepTask(entity)
                
                /// 执行任务
            case .doTask(let entityID, let task):
                self.doTask(entityID: entityID, task:task)
                
                /// 完成任务
            case .completeTask(let entityID, let task):
                self.completeTask(entityID: entityID,
                                  task: task)
                
                /// 将实体从搬运列表中移除
            case .removeFromHaulCategory(let entity):
                self.removeHaulEntity(entity: entity)
                
                /// 修改角色优先级
            case .updatePriorityEntity(let entity, let workType):
                self.updatePriorityEntity(entity: entity, workType: workType)
       
                /// 重新赋值父类
            case .reparentEntity(let entity,let z,let point):
                self.reparentNode(entity, z, point)
                
                /// 移动
            case .move(let points, let entity, let task):
                self.moveAction(points: points,
                           entity: entity
                           ,task: task)
            
            case .terminateForRemoveTaskOwner:
                self.terminateRemoveOnwer()
          
            case .pause: break
            case .speed1: break
            case .speed2: break
            case .speed3: break
            case .moveStop(_): break
            case .updateAllSystem(_,_): break
                
          
            case .eatTask(_):
                break
            case .relaxTask(_):
                break
            }
        }
    
    }
    
    
    /// 每帧调用
    func updateSystems(tick: Int) {
        
        /// 移动系统
        systemManager.getSystem(ofType: MovementSystem.self)?.moveUpdate(currentTick: tick)
        
        /// 动画系统
        systemManager.getSystem(ofType: DoTaskSystem.self)?.actionUpdate(currentTick: tick)
        
        /// 能量系统
        systemManager.getSystem(ofType: EnergySystem.self)?.energyUpdate(currentTick: tick)
        
        /// 饥饿值系统
        systemManager.getSystem(ofType: HungerSystem.self)?.hungerUpdate(currentTick: tick)
        
        /// 植物成长系统
        systemManager.getSystem(ofType: PlantGrowthSystem.self)?.growUpdate(currentTick: tick)
        
//        /// 任务系统
//        systemManager.getSystem(ofType: TaskSystem.self)?.eventUpdate()
        
    }
 
    
    /// 退出游戏删除一些运行时依赖
    func terminateRemoveOnwer() {
        systemManager.getSystem(ofType: TaskSystem.self)?.terminateAction()
    }
}


// MARK: - 实体 Entity -
extension ECSManager {
    
    /// 存储所有实体
    func saveEntity() {
        entityManager.save()
    }
    
    /// 添加实体
    func addEntity(_ entity: RMEntity) {
        
        entityManager.addEntity(entity)
        
        /// 渲染系统新增逻辑
        renderAdd(entity: entity)
        
        /// 分类新增实体逻辑
        categorizationAdd(entity: entity)
        
        /// 任务系统，刷新可搬运的任务列表
        characterTaskAdd(entity: entity)
        
    }
    
    
    
    /// 移除实体
    func removeEntity(_ entity: RMEntity) {
        
        /// 移除依赖关系
        OwnerShipTool.removeOwner(owned: entity, ecsManager: self)
       
        /// 渲染系统删除实体
        renderRemove(entity: entity)
        
        /// 分类列表中删除实体
        categorizationRemove(entity: entity)
        
        /// 任务系统删除实体
        characterTaskRemove(entity: entity)
        
        /// 从总的实体列表中移除
        entityManager.removeEntity(entity)
    }
    
  

    /// 获取所有实体
    func allEntities() -> [RMEntity] {
        return entityManager.allEntities()
    }
    
   
    /// 获取实体对应的Node
    func getEntityNode(_ entityId: Int) -> RMBaseNode? {
        return entityManager.getEntityNode(entityId)
    }
    
    /// 获取实体
    func getEntity(_ entityId: Int) -> RMEntity? {
        return entityManager.getEntity(entityId)
    }

    
    /// 初始化设置
    func setupAllEntityBehaviors(provider :PathfindingProvider) {
        
        /// 初始化分类系统
        systemManager.getSystem(ofType: EntityCategorizatonSystem.self)?.categorize()
        
        /// 初始化渲染系统
        systemManager.getSystem(ofType: RenderSystem.self)?.setupNodes()
        
        /// 初始化饥饿值系统
        systemManager.getSystem(ofType: HungerSystem.self)?.setupHunger()
        
        /// 初始化能量值系统
        systemManager.getSystem(ofType: EnergySystem.self)?.setupEnergy()
        
        /// 初始化娱乐值系统
        systemManager.getSystem(ofType: JoySystem.self)?.setupJoy()
        
        
        /// 初始化任务系统
        systemManager.getSystem(ofType: TaskSystem.self)?.setupTasks()
        
       
        /// 初始化不能行走的路径
        let allEntities = allEntities()
        for entity in allEntities {
            guard let wallComponent = entity.getComponent(ofType: WallComponent.self),
                  let pointComponent = entity.getComponent(ofType: PositionComponent.self) else { continue }
            provider.setWalkable(x: Int(pointComponent.x), y: Int(pointComponent.y), canWalk: false)
        }
        
    }
    
}


// MARK: - 实体任务事件 -
extension ECSManager {
    
    /// 强制任务转换
    func forceSwitchTask(entity: RMEntity,
                         task: WorkTask) {
        /// 任务终止，寻路系统
        pathFindingSystemEndFind(task: task)
        /// 任务终止，移动系统
        movementForceSwitchAction(entity: entity, task: task)
        /// 任务终止，动画系统
        doTaskSystemForceSwitchTask(entity, task)
        /// 任务终止，任务系统
        TaskSystemForceSwitchTask(entity: entity, task: task)
    }
    
    
  
    
   
}


// MARK: - 系统 System -
extension ECSManager {
    
     /// 获取所有系统
     func getSystems() -> [System] {
         return systemManager.getSystems()
     }
     
     /// 添加系统
     func addSystem(_ system: System) {
         systemManager.addSystem(system)
     }
     
     /// 更新所有系统
     func update(deltaTime: TimeInterval) {
         
         var dt = deltaTime - lastUpdateTime
         if dt > 0.1 { dt = 0 }
         self.lastUpdateTime = deltaTime
     }
}




