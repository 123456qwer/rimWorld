//
//  RMWorkTask.swift
//  RimWorld
//
//  Created by wu on 2025/7/28.
//

import Foundation


/// 任务
class WorkTask: Hashable {
    
    /// 任务类型 （通用）
    var type: WorkType
    
    /// 例如，可能是建造过程中生成的搬运任务，那么这个任务真实等级是建造
    var realType: WorkType
    
    /// 例如，采集，属于砍伐的子类
    var subType: SubWorkType = .None
    
    /// 任务类型 （高优先级，默认是无）
    var hightType: HightWorkType = .None
    
    /// 玩家设置的命令（最高优先级）
    var isUserSetTask: Bool = false
    
    /// 休息任务
    var restingTask: RestingTask = RestingTask()
    
    /// 吃饭任务
    var eatTask: EatTask = EatTask()
    
    /// 建造任务
    var buildingTask: BuindingTask = BuindingTask()
    
    /// 砍伐任务
    var cuttingTask: CuttingTask = CuttingTask()
    
    /// 搬运任务
    var haulingTask: HaulingTask = HaulingTask()
    
    /// 种植任务
    var growingTask: GrowingTask = GrowingTask()
    
    
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
        self.realType = type
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

/// 吃饭任务
struct EatTask: Hashable {
    /// 食物ID
    var targetID: Int = 0
    /// 吃饭状态
    var eatStage: EatTaskStage = .movingToItem
    
    /// 饱食度
    var restorePercent: CGFloat = 1.0
}

/// 搬运任务
struct HaulingTask: Hashable {
    /// 搬运状态
    var haulStage: HaulTaskStage?
    /// 搬运目的地
    var targetID: Int = 0
    
    /// 需要搬运的数量
    var needMaxCount: Int = 0
    
    /// 实际搬运的数量
    var currentCount: Int = 0
}

/// 种植任务
struct GrowingTask: Hashable {
    
    /// 目标位置（实际在scene上的位置）
    var targetPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// 种植空闲的位置，在这里生成植物
    var emptyIndex: Int = 0
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
