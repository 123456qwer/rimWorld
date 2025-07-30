//
//  RMWorkTask.swift
//  RimWorld
//
//  Created by wu on 2025/7/28.
//

import Foundation


/// 任务
class WorkTask: Hashable {
    
    /// 任务类型
    var type: WorkType
  
    
    /// 休息任务
    var restingTask: RestingTask = RestingTask()
    
    /// 建造任务
    var buildingTask: BuindingTask = BuindingTask()
    
    /// 砍伐任务
    var cuttingTask: CuttingTask = CuttingTask()
    
    /// 搬运任务
    var haulingTask: HaulingTask = HaulingTask()
    
    
    
    /// 任务目标，例如一棵树、一块矿
    var targetEntityID: Int = 0
    /// 执行者的实体ID，可选：未分配时为 nil
    var executorEntityID: Int = 0
 
    
    
    var isCompleted: Bool = false
    var isInProgress: Bool = false
    var isCancel: Bool = false
    
   
    let id: UUID = UUID()
  
    
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


/// 休息任务
struct RestingTask: Hashable {
    
}

/// 建造任务
struct BuindingTask: Hashable {
    
}

/// 砍伐任务
struct CuttingTask: Hashable {
    
}

/// 搬运任务
struct HaulingTask: Hashable {
    /// 搬运状态
    var haulStage: HaulTaskStage?
    /// 搬运目的地
    var targetId: Int = 0
    
    /// 需要搬运的数量
    var needMaxCount: Int = 0
    
    /// 实际搬运的数量
    var currentCount: Int = 0
}



/// 子任务（如建造任务，有子任务搬运）
struct SubTask: Hashable {
    /// 总共子任务数量
    var subTaskMaxCount:     Int = -1
    /// 当前创建了的子任务数量
    var subTaskCurrentCount: Int = -1
    /// 子任务数组
    var tasks:[WorkTask] = []
}
