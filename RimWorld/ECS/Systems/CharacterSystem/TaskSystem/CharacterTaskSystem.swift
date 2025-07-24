//
//  CharacterTaskSystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import Combine
import SpriteKit

class CharacterTaskSystem: System {
   
    /// 还没执行的任务队列
    var taskQueue:[WorkTask] = []
    /// 正在执行的任务队列
    var doTaskQueue: Set<WorkTask> = []
    /// 完成的任务
    var finishTaskQueue: Set<WorkTask> = []

    
    var cancellables = Set<AnyCancellable>()
    
    /// 有新事件，统一在下一帧执行，如果直接在返回的方法中执行，是同步的，会有问题
    var isUpEvent:Bool = false
    
    

    let ecsManager: ECSManager
    
    let taskDispatchQueue = DispatchQueue(label: "com.rm.taskEventQueue")

    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
    }
    
    /// 只有在有新事件生成时，加入到更新队列，因为sink方法是异步的，如果在sink中直接处理事件，会有一些列问题
    func eventUpdate(){
      
    }
    
    /// 初始化任务
    func taskInitAction() {
     
        /**
         任务队列，按照基础优先级排列
         */
        /** Firefighting | SelfCare | Doctor | Rest | Basic | Supervise | AnimalHandling | Cooking | Hunting | Building | Growing | Mining | Cutting | Smithing | Tailoring | Art | Crafting | Hauling | Cleaning | Research */
        
        /// 灭火
        generateFireFightingTask()
        /// 就医
        generateSelfCareTask()
        /// 行医
        generateDoctorTask()
        /// 修养
        generateRestTask()
        /// 基础
        generateBasicTask()
        /// 监管
        generateSuperviseTask()
        /// 驯兽
        generateAnimalHandingTask()
        /// 烹饪
        generateCookingTask()
        /// 狩猎
        generateHuntingTask()
        /// 建造
        generateBuildingTask()
        /// 种植
        generateGrowingTask()
        /// 采矿
        generateMiningTask()
        /// 砍伐任务
        generateCuttingTask()
        /// 锻造
        generateSmithingTask()
        /// 缝纫
        generateTailoringTask()
        /// 艺术
        generateArtTask()
        /// 制作
        generateCraftingTask()
        /// 搬运
        generateHaulingTask()
        /// 清洁
        generateCleaningTask()
        /// 研究
        generateResearchTask()

        /// 初始化任务完毕后，分配任务
        assignInitialTasks()
    }
 
    /// 初始化调用的任务分配队列
    private func assignInitialTasks() {
        
        /// 分配休息
        assignInitialRestTasks()
        /// 分配砍伐
        assignInitialCuttingTasks()
        /// 分配搬运
        assignInitialHaulingTasks()
        
        /// 分配完毕后开始执行任务
        let entities = ecsManager.entitiesAbleToTask()
        for entity in entities {
            EntityActionTool.doTask(entity: entity)
        }
        
        // 1. 找出将要移除的任务（executorEntityID != 0）
        let assignedTasks = taskQueue.filter { $0.executorEntityID != 0 }

        // 2. 加入到 doTaskQueue（Set 可避免重复）
        doTaskQueue.formUnion(assignedTasks)

        // 3. 从 taskQueue 中移除这些任务
        taskQueue.removeAll { $0.executorEntityID != 0 }

    }
    
    
    /// 消除一些运行时的依赖关系
    func terminateAction (){
        
        let haulTasks = doTaskQueue.filter{ $0.type == .Hauling }
        
        /// 删除进行时任务中的依赖关系
        for task in haulTasks {
            guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else {
                continue
            }
            OwnerShipTool.removeOwner(owned: targetEntity, ecsManager: ecsManager)
        }
    }
    
}

//MARK: - 实体变动 -
extension CharacterTaskSystem {
    
    /// 修改任务优先级
    func updatePriorityEntity(entity: RMEntity,
                              workType: WorkType) {
       
        /// 重置任务分类
        ecsManager.reloadEntityCategorization(workType: workType,
                                              entity: entity)
        isUpEvent = true
  
        /*
        /// 修改后的任务等级
        var nowWorkLevel = EntityInfoTool.workPriority(entity: entity, workType: workType)
        /// 等于0相当于无法做，变为最低优先级
        if nowWorkLevel == 0 {
            nowWorkLevel = 10000
        }
        
        /// 当前的任务等级
        let doWorkLevel = doTask.workLevel
        
        /// 任务类型相同
        if doTask.type == workType {
            /// 等级越小，直优先级越高，不需要强制转换任务
            if nowWorkLevel <= doWorkLevel {
                return
            }
        }
        
        var changeTask:WorkTask?
        /// 遍历任务，看是否需要强制切换任务
        for task in taskQueue {
            
            if task.type == workType { continue }
            
            /// 有比他小的，直接转换
            if task.workLevel < nowWorkLevel {
                /// 从任务队列中移除
                changeTask = task
                break
                
            }else if task.workLevel == nowWorkLevel {
                /// 相等，比优先级
                let type = EntityActionTool.compareTaskPriority(type1: task.type, type2: doTask.type)
                if type != doTask.type {
                    changeTask = task
                    break
                }
            }
        }
        
        /// 如果不需要强制转换，直接忽略
        guard let changeTask = changeTask else {
            return
        }
        
        /// 没有任务目标，也直接忽略
        guard let taskTarget = ecsManager.getEntity(changeTask.targetEntityID) else {
            return
        }

        
        /// 删除此任务
        removeNotDoTask(task: changeTask)
        
        /// 重新添加此任务，走执行逻辑
        switch changeTask.type {
        case .Hauling:
            RMEventBus.shared.requestHaulTask(taskTarget)
        case .Cutting:
            RMEventBus.shared.requestCuttingTask(entity: taskTarget, canChop: true)
        default:
            break
        }
        */
    }
    
    
    
}


//MARK: - 任务 -
extension CharacterTaskSystem {
    
    /// 执行任务
    func doTask(entityID: Int, task: WorkTask) {
        guard let node = ecsManager.getEntityNode(entityID) else {
            ECSLogger.log("没有找到对应的执行者")
            return
        }
        
        guard let entity = node.rmEntity else {
            ECSLogger.log("执行者没有实体")
            return
        }
        
        guard entity.getComponent(ofType: TaskQueueComponent.self) != nil else {
            ECSLogger.log("实体没有任务队列组件")
            return
        }
        
        /// 执行任务
        switch task.type {
        case .Firefighting:
            ECSLogger.log("开始灭火！")
        case .SelfCare:
            ECSLogger.log("开始就医！")
        case .Doctor:
            ECSLogger.log("开始治疗")
        case .Rest:
            ECSLogger.log("开始执行休息任务！")
            doRestTask(task)
        case .Basic:
            ECSLogger.log("开始基本工作！")
        case .Supervise:
            ECSLogger.log("开始监管！")
        case .AnimalHandling:
            ECSLogger.log("开始驯兽！")
        case .Cooking:
            ECSLogger.log("开始烹饪！")
        case .Hunting:
            ECSLogger.log("开始狩猎！")
        case .Building:
            ECSLogger.log("开始建造！")
        case .Growing:
            ECSLogger.log("开始种植！")
        case .Mining:
            ECSLogger.log("开始采矿！")
        case .Cutting:
            ECSLogger.log("开始执行割除任务！")
            doCuttingTask(task)
        case .Smithing:
            ECSLogger.log("开始锻造！")
        case .Tailoring:
            ECSLogger.log("开始缝纫！")
        case .Art:
            ECSLogger.log("开始艺术！")
        case .Crafting:
            ECSLogger.log("开始手工制作！")
        case .Hauling:
            ECSLogger.log("开始搬运！")
            doHaulingTask(task)
        case .Cleaning:
            ECSLogger.log("开始清洁！")
        case .Research:
            ECSLogger.log("开始研究！")
        }
        
        /*
        /// 遍历所有任务，但是只执行第一个任务
        for task in taskComponent.tasks {
            /// 只执行第一个任务
            return
        }
         */
    }
    
    /// 完成任务
    func completeTask(entityID: Int,
                      task: WorkTask) {
  
        guard let entity = ecsManager.getEntity(entityID) else {
            ECSLogger.log("此完成任务的实体已经不存在了")
            return
        }
        
        ECSLogger.log("实体完成了任务：\(task.type.rawValue)")

        /// 完成以后，移除实体
        EntityActionTool.removeTask(entity: entity, task: task)

        removeDoTask(task: task)
        
        finishTaskQueue.insert(task)
        
        assignNextTask(entity)
    }
    
    /// 中断任务（任务转换）
    func forceSwitchTask(entity: RMEntity,
                         task: WorkTask) {
        
        switch task.type {
        case .Cutting:
            cancelCutting(entityID: entity.entityID, task: task)
        case .Rest:
            cancelRest(entity: entity, task: task)
        case .Hauling:
            cancelHauling(entity: entity, task: task)
        default:
            break
        }
        
        addForceSwitchTask(task: task)
    }
    
    /// 添加强制替换的任务
    func addForceSwitchTask(task: WorkTask) {
        if task.isCompleted {
            ECSLogger.log("此任务已经完成了！")
        }
        
        taskQueue.append(task)
        sortTaskQueue()
    }
    
    
    /// 实体执行完任务后，重新分配新任务，以后如果卡顿，优化用吧
    func assignNextTask(_ entity: RMEntity) {
        
        guard !taskQueue.isEmpty else {
            ECSLogger.log("当前任务队列为空，所以不继续分配任务了！💀💀💀")
            return
        }
        
        let allCanDoTaskType = EntityInfoTool.allCanDoTask(entity)
        
        // 1. 构建 WorkType -> 优先级（位置）映射表
        let taskPriorityMap: [WorkType: Int] = Dictionary(
            uniqueKeysWithValues: allCanDoTaskType.enumerated().map { ($0.element, $0.offset) }
        )

        let entityPosition = PositionTool.nowPosition(entity)
        
        // 筛选出当前实体可以执行的任务，并按优先级排序
        let filteredSortedTasks = taskQueue
            .filter { taskPriorityMap[$0.type] != nil } // 只保留实体能执行的任务
            .sorted {                                     // 按优先级排序
                let priorityA = taskPriorityMap[$0.type]!
                let priorityB = taskPriorityMap[$1.type]!
                
                if priorityA != priorityB {
                    return priorityA < priorityB // 优先级不同：按优先级排
                }
                
                var posA = CGPoint(x: 0, y: 0)
                var posB = CGPoint(x: 0, y: 0)
                // 优先级相同：按距离排
                if let a = ecsManager.getEntity($0.targetEntityID){
                    posA = PositionTool.nowPosition(a)
                }
                if let b = ecsManager.getEntity($1.targetEntityID){
                    posB = PositionTool.nowPosition(b)
                }
                let distanceA = MathUtils.distance(entityPosition, posA)
                let distanceB = MathUtils.distance(entityPosition, posB)
                return distanceA < distanceB
        }
        
        /// 执行任务
        if let task = filteredSortedTasks.first {
            
            if task.type == .Cutting {
                handleCuttingTaskWithEntity(task: task,
                                            entity: entity)
            }else if task.type == .Hauling {
                handleHaulingTaskWithEntity(task: task,
                                            entity: entity)
            }
       
        }else{
            ECSLogger.log("当前实体没有能执行的任务啊！💀💀💀")
        }
        
    }
    
}



//MARK: - TOOL ACTION -
extension CharacterTaskSystem {
    
    /// 工具方法： 排序任务，优先级（工作类型正序）
    func sortTaskQueue() {
        taskQueue.sort {
            guard let indexA = WorkType.allCases.firstIndex(of: $0.type),
                  let indexB = WorkType.allCases.firstIndex(of: $1.type) else {
                return false
            }
            return indexA < indexB
        }
    }
    
    
    /// 工具方法： 删除还未做的任务（taskQueue）
    func removeNotDoTask(task: WorkTask) {
        if let index = taskQueue.firstIndex(where: { $0.id == task.id }){
            taskQueue.remove(at: index)
            ECSLogger.log("成功从未执行队列中删除了此任务：\(task.type.rawValue)")
        }else{
            ECSLogger.log("从未执行队列中删除此任务失败：\(task.type.rawValue)")
        }
    }
    
    /// 工具方法： 删除正在做的任务（doTaskQueue）
    func removeDoTask(task: WorkTask) {
        if let index = doTaskQueue.firstIndex(where: { $0.id == task.id }){
            doTaskQueue.remove(at: index)
            ECSLogger.log("实体成功删除了任务：\(task.type.rawValue)")
        }
    }
    
    
    /// 工具方法：最终可执行人
    func ableToDoTaskEntity(ableEntities: [RMEntity],
                            task: WorkTask) -> RMEntity? {
        
        var notWorkEntitys:[RMEntity] = []
        
        var exectorEntity: RMEntity?

        /// 优先当前没有任务的实体执行
        for entity in ableEntities {
            
            if EntityInfoTool.currentTask(entity) == nil {
                notWorkEntitys.append(entity)
            }
            
            if exectorEntity == nil {
                if EntityAbilityTool.ableForceSwitchTask(entity: entity, task: task) {
                    exectorEntity = entity
                }
            }
        }
        
        
        if notWorkEntitys.isEmpty == false {
            /// 空闲角色，直接分配任务
            exectorEntity = notWorkEntitys.first!
        }
        
        return exectorEntity
    }
    

    /// 工具方法：有目标的任务，如砍树、搬运，就近排序
    func assignTaskForAbleEntities(ableEntities: [RMEntity],
                                   ableTasks: [ WorkTask]) {
        
        var tasks = ableTasks
        var ableEntities = ableEntities
        
        /// 就近排序
        tasks.sort { task1, task2 in
            guard let entity1 = ecsManager.getEntity(task1.targetEntityID),
                  let entity2 = ecsManager.getEntity(task2.targetEntityID) else {
                return false
            }
            let pos1 = PositionTool.nowPosition(entity1)
            let pos2 = PositionTool.nowPosition(entity2)
            
            let minDist1 = ableEntities.map { MathUtils.distance(pos1, PositionTool.nowPosition($0)) }.min() ?? .greatestFiniteMagnitude
            let minDist2 = ableEntities.map { MathUtils.distance(pos2, PositionTool.nowPosition($0)) }.min() ?? .greatestFiniteMagnitude

            return minDist1 < minDist2
        }
        
        /// 分配任务
        assignTasks(tasks, to: &ableEntities)
    }
    
    /// 工具方法：根据排好序的任务列表（由近到远）分配任务
    private func assignTasks(_ tasks: [WorkTask],
                     to ableEntities: inout [RMEntity]) {
        guard !tasks.isEmpty else { return }
        guard !ableEntities.isEmpty else { return }

        for task in tasks {
            // 获取目标实体
            guard let targetEntity = ecsManager.getEntity(task.targetEntityID) else { continue }
            let targetPos = PositionTool.nowPosition(targetEntity)

            var nearestExecutor: RMEntity?
            var nearestIndex: Int?
            var nearestDistance = CGFloat.greatestFiniteMagnitude

            /// 是否可以强制切换任务
            for (index, entity) in ableEntities.enumerated() {
                guard EntityAbilityTool.ableForceSwitchTask(entity: entity, task: task) else { continue }

                let distance = MathUtils.distance(PositionTool.nowPosition(entity), targetPos)
                if distance < nearestDistance {
                    nearestDistance = distance
                    nearestExecutor = entity
                    nearestIndex = index
                }
            }

            // 如果找到了最近执行者，分配任务并移除
            if let executor = nearestExecutor, let index = nearestIndex {
                ableEntities.remove(at: index)
                task.executorEntityID = executor.entityID
                EntityActionTool.addTask(entity: executor, task: task)
            }
        }
    }
}
