//
//  DefenseComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import WCDBSwift

final class DefenseComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 对利器的护甲值（%）
    var sharpArmor: Double = 0.0

    /// 对钝器的护甲值（%）
    var bluntArmor: Double = 0.0

    /// 对热能的护甲值（%）
    var heatArmor: Double = 0.0
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DefenseComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case sharpArmor
        case bluntArmor
        case heatArmor
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
