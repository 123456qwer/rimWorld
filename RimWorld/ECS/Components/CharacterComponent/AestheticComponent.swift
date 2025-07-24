//
//  AestheticComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import WCDBSwift

/// 美观度
final class AestheticComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 美观度
    var aesthetic:Int = 100
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = AestheticComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case aesthetic
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
