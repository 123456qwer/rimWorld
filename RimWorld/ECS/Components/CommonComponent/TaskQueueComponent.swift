//
//  TaskQueueComponent.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import WCDBSwift


/// 执行任务队列组件
final class TaskQueueComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 将任务添加到任务队列中
    var tasks: [WorkTask] = []
    
  
    /// 任务完成
    func completeTask(task: WorkTask){
        /// 完成任务后，从任务中移除
        RMEventBus.shared.publish(.completeTask(entityID: entityID,
                                                task: task))
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TaskQueueComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID

    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}

enum HaulTaskStage {
    /// 前往物品
    case movingToItem
    /// 正在搬运到目标位置
    case movingToTarget
}

/// 任务
class WorkTask: Hashable {
    
    /// 任务类型
    var type: WorkType
    
    
    /// 可能是建造过程中的搬运任务
    var realType:WorkType?
    
    
    /// 任务目标，例如一棵树、一块矿
    var targetEntityID: Int = 0
    /// 执行者的实体ID，可选：未分配时为 nil
    var executorEntityID: Int = 0
    
    /// 可能需要额外的任务目标（比如搬运，需要存储信息）
    var targetEntityID2: Int = 0
    
    
    var isCompleted: Bool = false
    var isInProgress: Bool = false
    
    /// 蓝图状态下，是否材料齐全
    var isMaterialComplete: Bool = false
    
    /// 越大，执行级别越高，为-1，默认非必要
    var mustDo:Int = -1
    let id: UUID = UUID()
    
    
    /// 有可能是建造任务，然后得先执行搬运，所以这个搬运任务实际是建造任务。。。。。
    /// 默认-1，就是任务对应的type
    var realTaskLevel: Int = -1
    
    
    /// 搬运状态
    var haulStage: HaulTaskStage?
    
   
    
    
    
    static func == (lhs: WorkTask, rhs: WorkTask) -> Bool {
        return lhs.id == rhs.id // 比较依据
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // 基于唯一 ID
    }
    
    init(type: WorkType,
         targetEntityID: Int,
         executorEntityID: Int) {
        
        self.type = type
        self.targetEntityID = targetEntityID
        self.executorEntityID = executorEntityID
        
    }
    
    

}
