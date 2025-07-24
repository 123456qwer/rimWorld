//
//  JoyComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import WCDBSwift

/// 娱乐
final class JoyComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1

    var total:Double = 100
    var current:Double = 100
    var threshold:Double = 15
    
    var reduce:Double = 1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = JoyComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case total
        case current
        case threshold
        case reduce
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
