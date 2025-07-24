//
//  CarryingCapacityComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import WCDBSwift

/// 负重
final class CarryingCapacityComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 当前负重（kg）
    var currentLoad: Double = 0.0
    /// 最大负重
    var maxCapacity: Double = 35.0
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = CarryingCapacityComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case currentLoad
        case maxCapacity
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
