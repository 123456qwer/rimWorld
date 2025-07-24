//
//  MovementBoundsComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import WCDBSwift

/// 活动区域
final class MovementBoundsComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 总值
    var total: Double = 100
    /// 初始值
    var current: Double = 100
    /// 状态描述
    var status: String = "无限制"
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MovementBoundsComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case total
        case current
        case status

        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
