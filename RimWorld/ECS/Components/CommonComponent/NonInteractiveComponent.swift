//
//  NonInteractiveComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation
import WCDBSwift

/// 不可点击标识组件
final class NonInteractiveComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = NonInteractiveComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
