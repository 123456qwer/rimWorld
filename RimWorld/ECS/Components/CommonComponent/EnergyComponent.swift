//
//  EnergyComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import WCDBSwift

/// 精力值
final class EnergyComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var total:Double = 100
    var current:Double = 40
    
    /// 休息阈值
    var threshold3:Double = 15
    var threshold2:Double = 25
    var threshold1:Double = 30

    
    /// 回复速度
    var restRestorePerTick: Double = 0.1
    
    /// 每次减少的休息值
    var restDecayPerTick:Double = 0.1
    
    /// 是否在休息
    var isResting:Bool = false
    
    /// 状态描述
    var status: String = textAction("Rest")
    
    /// 是否已经发送了任务，避免一直发送休息任务
    var alreadySend:Bool = false
    
    /// 为0，强制休息任务
    var zeroSend:Bool = false
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = EnergyComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case total
        case current
        case threshold3
        case threshold2
        case threshold1
        case restRestorePerTick
        case restDecayPerTick
        case isResting
        case status

        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
