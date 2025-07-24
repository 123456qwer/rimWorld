//
//  PositionComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
import WCDBSwift

/// 位置组件
final class PositionComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    
    var sleepX: Double = 0
    var sleepY: Double = 0
    
    
    enum CodingKeys:String, CodingTableKey{
        typealias Root = PositionComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID,isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case x
        case y
        case z
        case sleepX
        case sleepY
    }
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
    
}
