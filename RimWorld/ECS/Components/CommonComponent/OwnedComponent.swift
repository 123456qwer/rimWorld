//
//  OwnedComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import WCDBSwift

/// 此组件标识当前实体被谁拥有
final class OwnedComponent: TableCodable, Component {
    
    var entityID:Int = -1
    
    var componentID:Int = -1
    
    /// 持有人实体ID
    var ownedEntityID:Int = -1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = OwnedComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true, isAutoIncrement: false)
        }
        
        case ownedEntityID
        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
    
}
