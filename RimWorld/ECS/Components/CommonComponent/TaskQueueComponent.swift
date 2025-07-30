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









