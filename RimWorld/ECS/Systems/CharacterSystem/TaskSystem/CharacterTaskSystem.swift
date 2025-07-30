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

    
    /// 所有任务
    var allTaskQueue: [WorkTask] = []
    /// 正在执行的任务队列
    var doTaskQueue: Set<WorkTask> = []
    /// 完成的任务
    var finishTaskQueue: Set<WorkTask> = []
    
    
    
    var cancellables = Set<AnyCancellable>()
   
    let provider: PathfindingProvider
    
    let ecsManager: ECSManager

    init (ecsManager: ECSManager,
          provider: PathfindingProvider) {
        self.ecsManager = ecsManager
        self.provider = provider
    }
    

    
    /// 初始化任务
    func setupTasks() {
     
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
        assignTask()
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
            doBuildingTask(task)
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
            ECSLogger.log("此完成任务的实体已经不存在了，💀💀💀")
            return
        }
        
        ECSLogger.log("实体完成了任务：\(task.type.rawValue)")

        /// 完成以后，移除实体任务列表中的任务
        EntityActionTool.removeTask(entity: entity, task: task)

        removeDoTask(task: task)
        finishTaskQueue.insert(task)
        
        
        guard let stateComponent = entity.getComponent(ofType: ActionStateComponent.self) else {
            ECSLogger.log("当前执行任务的角色：\(entity.name)没有状态组件。💀💀💀")
            return
        }
        
        /// 更改角色状态
        stateComponent.actions.append(textAction("闲逛"))
        /// 同步到视图
        RMInfoViewEventBus.shared.publish(.updateCharacter)
        
        
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
        case .Building:
            cancelBuilding(entity: entity, task: task)
        default:
            break
        }
        
    }
  
    
    
    /// 实体执行完任务后，重新分配新任务，以后如果卡顿，优化用吧
    func assignNextTask(_ entity: RMEntity) {
        assignTask(executorEntity: entity)
    }
    
    
}



//MARK: - TOOL ACTION -
extension CharacterTaskSystem {
    

    /// 工具方法： 删除正在做的任务（doTaskQueue）
    func removeDoTask(task: WorkTask) {
        doTaskQueue.remove(task)
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
