//
//  EntityActionTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 EntityAction 工具类 🚩 -
/// 实体行为工具类
struct EntityActionTool {
    
    /// 设置搬运走的数量
    static func setHaulingCount(entity: RMEntity,
                                count: Int) {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else { return }
        haulComponent.currentCount = count
        
        EntityNodeTool.updateHaulCountLabel(entity: entity, count: count)
    }
    
    /// 在实际搬运的时候，要考虑搬运人负重，所以需要更新蓝图对应的搬运中的素材数量
    static func setBlueprintHaulTaskCount(entity: RMEntity,
                                          blueEntity:RMEntity,
                                          count: Int){
        guard let blueComponent = blueEntity.getComponent(ofType: BlueprintComponent.self) else { return }
        
        let materialType = EntityInfoTool.materialType(entity)
        blueComponent.alreadyCreateHaulTask[materialType]?[entity.entityID] = count
    }
    
    /// 对应的存储仓库
    static func storageEntity(entity: RMEntity,
                              ecsManager: ECSManager) -> RMEntity?{
        guard let ownedComponent = entity.getComponent(ofType: OwnedComponent.self) else {
            return nil
        }
        
        return ecsManager.getEntity(ownedComponent.ownedEntityID)
        
    }
    
    /// 执行任务
    static func doTask(entity: RMEntity) {
        guard let taskComponent = entity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("执行任务失败，\(entity.name)没有任务列表。💀💀💀")
            return
        }

        guard let task = taskComponent.tasks.first else {
            ECSLogger.log("开始执行任务失败，任务列表为空。💀💀💀")
            return
        }

        guard let stateComponent = entity.getComponent(ofType: ActionStateComponent.self) else {
            ECSLogger.log("当前执行任务的角色：\(entity.name)没有状态组件。💀💀💀")
            return
        }
        
        
        /// 更改角色状态
        stateComponent.actions.append(EntityActionTool.taskDescription(task))
        /// 同步到视图
        RMInfoViewEventBus.shared.publish(.updateCharacter)
        
        RMEventBus.shared.publish(.doTask(entityID: entity.entityID, task: task))
    }
    
    /// 完成任务
    static func completeTaskAction(entity: RMEntity,
                                   task: WorkTask) {
        
        task.isCompleted = true
        
        guard let workComponent = entity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("此实体没有任务组件")
            return
        }
        
        if let index = workComponent.tasks.firstIndex(where: { $0.id == task.id }) {
            workComponent.tasks.remove(at: index)
        }else {
            ECSLogger.log("在实体队列中的任务删除失败，没找到Index💀💀💀")
        }
        
        writeLog(entity: entity, text: "完成了任务：\(task.type)")
        
        workComponent.completeTask(task: task)
    }
    
    /// 添加任务
    static func addTask(entity: RMEntity,
                 task: WorkTask) {
        guard let taskCompnent = entity.getComponent(ofType: TaskQueueComponent.self) else { return }
        taskCompnent.tasks.insert(task, at: 0)
    }
    
    /// 移除任务
    static func removeTask(entity: RMEntity,
                           task: WorkTask) {
        guard let taskCompnent = entity.getComponent(ofType: TaskQueueComponent.self) else { return }
        if let index = taskCompnent.tasks.firstIndex(where: {
            $0.id == task.id
        }){
            taskCompnent.tasks.remove(at: index)
        }
        
        if taskCompnent.tasks.count > 1 {
            ECSLogger.log("为什么会大于一个任务？？？？💀💀💀")
        }
    }
    
    /// 设置开始休息状态
    static func startSleeping(entity: RMEntity){
        
        guard let energyComponent = entity.getComponent(ofType: EnergyComponent.self) else {
            ECSLogger.log("开始休息动画失败，未找到执行人能量组件👻👻👻")
            return
        }
        
        ECSLogger.log("设置实体进入休息队列中！😏")

        energyComponent.isResting = true
        /// 实体休息状态改变
        RMEventBus.shared.publish(.restStatusChange(entity: entity, isRest: true))
        energyComponent.alreadySend = false
        
    }
    
    /// 返回任务的描述文本
    static func taskDescription(_ task: WorkTask) -> String {
        switch task.type {
        case .Firefighting:
            return textAction("正在灭火")
        case .SelfCare:
            return textAction("正在自我治疗")
        case .Doctor:
            return textAction("正在治疗其他人")
        case .Rest:
            return textAction("正在休息")
        case .Basic:
            return textAction("正在执行基础任务")
        case .Supervise:
            return textAction("正在监管")
        case .AnimalHandling:
            return textAction("正在驯兽")
        case .Cooking:
            return textAction("正在烹饪")
        case .Hunting:
            return textAction("正在狩猎")
        case .Building:
            return textAction("正在建造")
        case .Growing:
            return textAction("正在种植")
        case .Mining:
            return textAction("正在采矿")
        case .Cutting:
            return textAction("正在砍树")
        case .Smithing:
            return textAction("正在锻造")
        case .Tailoring:
            return textAction("正在缝纫")
        case .Art:
            return textAction("正在进行艺术创作")
        case .Crafting:
            return textAction("正在制作物品")
        case .Hauling:
            return textAction("正在搬运")
        case .Cleaning:
            return textAction("正在清洁")
        case .Research:
            return textAction("正在研究")
        case .None:
            return textAction("未知")
        }
    }
    
    /// 实体写日志
    static func writeLog(entity: RMEntity,
                         text:String){
        let eventLog = DBManager.shared.getEventLog()
        eventLog.addLog(from: entity.entityID, to: entity.entityID, content: text, emotion: .neutral)
        DBManager.shared.updateEventLog(eventLog)
    }
    
    
    /// 取消操作
    static func cancelAction(entity:RMEntity) {
        let type = entity.type
        if type == kTree {
            RMEventBus.shared.requestCuttingTask(entity: entity,
                                                 canChop:false)
            RMInfoViewEventBus.shared.requestPlantInfo()
        }else if type == kBlueprint {
            let reason = BlueprintRemoveReason(entity: entity)
            /// 移除
            RMEventBus.shared.requestRemoveEntity(entity,reason: reason)
        }
    }
   
    /// 割除操作
    static func cuttingAction(entity: RMEntity,
                              ecsManager: ECSManager) {
        let type = entity.type
        if type == kTree {
            
            /// 去重
            if EntityAbilityTool.ableToAddTask(entity: entity, ecsManager: ecsManager) == false {
                return
            }
            
            RMEventBus.shared.requestCuttingTask(entity: entity,
                                                 canChop:true)
            RMInfoViewEventBus.shared.requestPlantInfo()
        }
    }
    
    /// 采矿操作
    static func miningAction(entity: RMEntity,
                              ecsManager: ECSManager) {
        let type = entity.type
        if type == kStone {
            
            /// 去重
            if EntityAbilityTool.ableToAddTask(entity: entity, ecsManager: ecsManager) == false {
                return
            }
            
            RMEventBus.shared.requestMiningTask(entity: entity, canMine: true)
            RMInfoViewEventBus.shared.requestPlantInfo()
        }
    }
    
    
    /// 比较任务优先级
    /// 相等优先级情况下，对比type
    static func compareTaskPriority(type1:WorkType,
                                    type2:WorkType) -> WorkType{
        // 根据定义顺序决定优先级，越靠前越高
        let priorityList: [WorkType] = WorkType.allCases

        // 获取两个 type 在列表中的索引
        guard let index1 = priorityList.firstIndex(of: type1),
              let index2 = priorityList.firstIndex(of: type2) else {
            // 如果找不到，默认返回 type1
            return type1
        }

        // 谁的 index 更小，说明优先级更高
        return index1 <= index2 ? type1 : type2
    }
}
