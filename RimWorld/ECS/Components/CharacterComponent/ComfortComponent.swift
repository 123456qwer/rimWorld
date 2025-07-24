//
//  ComfortComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import WCDBSwift

/// 舒适度
final class ComfortComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 舒适度
    var comfort:Int = 100
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ComfortComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case comfort
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
