//
//  TaskAssign.swift
//  RimWorld
//
//  Created by wu on 2025/7/28.
//

import Foundation

/// 任务分配
extension TaskSystem {
    
    /// 分配任务 （如生成新实体等，会调用此方法）
    func assignTask(){
                
        /// 所有可执行任务的实体
        let entities = ecsManager.entitiesAbleToTask()
        

        for entity in entities {
            /// 根据当前实体，遍历到最优的任务
            assignTask(executorEntity: entity)
        }

    }
    
    
    /// 针对单个实体，可直接调用
    func assignTask(executorEntity: RMEntity) {
        
        /// 排序
        sortTask(entity: executorEntity)
        
        /// 然后遍历当前任务清单
        for task in allTaskQueue {
            
            /// 这种任务只能自己执行
            if (task.type == .Rest || task.hightType == .Sleep || task.hightType == .Eat || task.hightType == .Relax) && task.targetEntityID != executorEntity.entityID {
                continue
            }
            
            if EntityAbilityTool.ableForceSwitchTask(entity: executorEntity, task: task) {
                
                task.isCancel = false
                
                /// 处理任务
                handleTask(executorEntity: executorEntity, task: task)
                
                /// 从任务列表中移除次任务
                if let index = allTaskQueue.firstIndex(where: { $0.id == task.id }){
                    allTaskQueue.remove(at: index)
                    doTaskQueue.insert(task)
                }
                
                return
            }
        }

    }
    
    
    /// 按优先级排列任务
    func sortTask(entity: RMEntity) {
       
        /// 先按距离顺序排序
        allTaskQueue.sort {
            
            let target1 = ecsManager.getEntity($0.targetEntityID) ?? RMEntity()
            let target2 = ecsManager.getEntity($1.targetEntityID) ?? RMEntity()
            
            var pos1 = PositionTool.nowPosition(target1)
            var pos2 = PositionTool.nowPosition(target2)
            
            /// 种植的位置
            if target1.type == kGrowingArea {
                pos1 = $0.growingTask.targetPoint
            }
            if target2.type == kGrowingArea {
                pos2 = $1.growingTask.targetPoint
            }
            
            let entityPoint = PositionTool.nowPosition(entity)
            
            let distance1 = MathUtils.distance(entityPoint, pos1)
            let distance2 = MathUtils.distance(entityPoint, pos2)
            
            
            return distance1 < distance2
        }
        
        /// 在按任务优先级排序
        allTaskQueue.sort {
            let p1 = EntityInfoTool.workPriority(entity: entity, workType: $0.realType)
            let p2 = EntityInfoTool.workPriority(entity: entity, workType: $1.realType)

            // 优先级为 0 或负数的排在最后
            if p1 <= 0 && p2 <= 0 {
                return false
            } else if p1 <= 0 {
                return false
            } else if p2 <= 0 {
                return true
            }
            
            // 优先级不同，优先级小的排前面（更高优先）
            if p1 != p2 {
                return p1 < p2
            }
            
            
            let allTypes = WorkType.allCases
            if let idx1 = allTypes.firstIndex(of: $0.type),
               let idx2 = allTypes.firstIndex(of: $1.type) {
                return idx1 < idx2
            }
            
            return false
            
        }
        
    }
    
    
    /// 根据任务不同，做相应设置
    func handleTask(executorEntity: RMEntity, task: WorkTask) {
        
        /// 取消之前的任务（如果有）
        let cancelTask = EntityInfoTool.currentTask(executorEntity)
        if let cancelTask = cancelTask {
            cancelTask.isCancel = true
            RMEventBus.shared.requestForceCancelTask(entity: executorEntity, task: cancelTask)
        }
        
        /// 将任务添加到执行队列中
        EntityActionTool.addTask(entity: executorEntity, task: task)
        
        /// 根据类型处理当前要执行的任务
        switch task.type {
        case .Cutting:
            handleCuttingTask(executorEntity: executorEntity, task: task)
        case .Rest:
            handleRestingTask(executorEntity: executorEntity, task: task)
        case .Hauling:
            handleHaulingTask(executorEntity: executorEntity, task: task)
        case .Building:
            handleBuildingTask(executorEntity: executorEntity, task: task)
        case .Growing:
            handleGrowingTask(executorEntity: executorEntity, task: task)
        case .Mining:
            handleMiningTask(executorEntity: executorEntity, task: task)
        default:
            break
        }
        
        /// 执行任务
        EntityActionTool.doTask(entity: executorEntity)
    }
    
}


/// 中断任务
extension TaskSystem {
    
    /// 从任务队列中删除任务
    func removeTaskFromAllTaskQueue(entity: RMEntity){
        if let index = allTaskQueue.firstIndex(where: {
            $0.targetEntityID == entity.entityID
        }){
            allTaskQueue.remove(at: index)
        }
    }
    
}





/// 任务生成
extension TaskSystem {
    
    /// 是否可以生成搬运任务到存储区域
    @discardableResult
    func ableToStorageForHaulingTask(storageE: RMEntity,
                                             targetEntity: RMEntity,
                                             haulComponent: HaulableComponent) -> Bool {
        
        guard let storageComponent = storageE.getComponent(ofType: StorageInfoComponent.self) else {
            return false
        }
        
        
        
        /// 如果在存储区，看下是否是当前存储区，如果是，直接返回失败
        if let ownedComponent = targetEntity.getComponent(ofType: OwnedComponent.self) {
            
            /// 如果在存储区，等级不小于目标存储区，不创建搬运任务
            let existingStroage = ecsManager.getEntity(ownedComponent.ownedEntityID)
            
            /// 相同仓库
            if ownedComponent.ownedEntityID == storageE.entityID {
                return false
            }
                
            /// 不同仓库
            if let existingStorageComponent = existingStroage?.getComponent(ofType: StorageInfoComponent.self){
                
                /// 比优先级
                let isExistingHight = existingStorageComponent.priority >= storageComponent.priority
                
                /// 在比较之前的仓库是否还允许存放此元素
                let existingCanStorage = EntityAbilityTool.ableToStorage(storage: existingStroage ?? RMEntity(), material: targetEntity)
                
                if isExistingHight == true && existingCanStorage == true {
                    return false
                }
                
            }
        }
        
        
        /// 说明可以存储此类型
        if EntityAbilityTool.ableToStorage(storage: storageE, material: targetEntity) == true {
            
            /// 在判断当前类型下的数据是否满了
            let size = storageComponent.size
            let cols = Int(size.width / tileSize)
            let rows = Int(size.height / tileSize)
            // 存储区域总格子数
            let totalTiles = abs(cols * rows)
            /// 当前格子上存储的实体
            let storageEntities = storageComponent.saveEntities
            
            /// 存储的位置
            var selectIndex = -1
            
            /// 遍历格子，看是否有能存储的位置
            for index in 0..<totalTiles {
                /// 存储的实体
                if let storageEntity = ecsManager.getEntity(storageEntities[index] ?? -1) {
                    /// 存储类型相同
                    if storageEntity.type == targetEntity.type {
                        
                        guard let storageHaulComponent = storageEntity.getComponent(ofType: HaulableComponent.self) else { continue }
                        /// 最大存储
                        let maxLimit = storageHaulComponent.stackLimit
                        /// 当前存储
                        let current = storageHaulComponent.currentCount
                        /// 存满了，直接下一个栏位
                        if maxLimit == current { continue }
                        /// 未存满，但是加上当前要搬运的，大于最大值，直接下一个栏位
                        if current + haulComponent.currentCount > maxLimit { continue }
                    }
                }
                
                selectIndex = index
                break
            }
            
            /// 不等于-1说明有存储空间
            if selectIndex != -1 {
                /// 创建搬运任务
                let task = addHaulingTask(targetEntity)
                /// 设置搬运目的地
                task?.haulingTask.targetId = storageE.entityID
                return true
            }
        }
        
        
        return false
    }
    
    
    /// 是否可以生成搬运任务到蓝图
    @discardableResult
    func ableToBlueprintForHaulingTask(blueE: RMEntity,
                                               targetMaterialType: MaterialType,
                                               targetEntity: RMEntity) -> Bool{
        
        guard let blueComponent = blueE.getComponent(ofType: BlueprintComponent.self) else {
            return false
        }
        
        for (key, count) in blueComponent.alreadyMaterials {
            
            let maxCount = blueComponent.materials[key] ?? 0
            let materialType = MaterialType(rawValue: Int(key)!)
            
            
            /// 蓝图需要的类型相同,且原材料剩余为空
            if materialType == targetMaterialType {
               
                var alreadyHaulDic = blueComponent.alreadyCreateHaulTask[materialType!] ?? [:]
                /// 搬运中的数量
                var haulCount = 0
                for (_,value) in alreadyHaulDic{
                    haulCount += value
                }
           
                /// 实际还需要搬运的数量
                let needHaulCount = maxCount - haulCount - count
         
                /// 目标物品的数量
                let targetCount = EntityInfoTool.haulingCount(targetEntity)

                /// 实际可搬运的数量
                let actualCount = min(targetCount, needHaulCount)
              
                
                if actualCount > 0 {
                    /// 创建搬运任务
                    let task = addHaulingTask(targetEntity)
                    /// 需要搬的数量（走到位置后计算实际搬运数量）
                    task?.haulingTask.needMaxCount = needHaulCount
                    /// 设置搬运目的地
                    task?.haulingTask.targetId = blueE.entityID
                    
                    /// 实际等级是建造
                    task?.realType = .Building
                    
                    /// 设置数量
                    alreadyHaulDic[targetEntity.entityID] = actualCount
                    
                    /// 实际搬运的数量
                    blueComponent.alreadyCreateHaulTask[materialType!] = alreadyHaulDic
                    
                    return true

                }
                
            }

        }
        
        return false
    }
}
