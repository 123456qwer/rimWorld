//
//  CategorizationComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import WCDBSwift

/// 分类组件，一般用于建筑材料
final class CategorizationComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 分类
    var categorization: Int = MaterialType.wood.rawValue
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = CategorizationComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case categorization
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
