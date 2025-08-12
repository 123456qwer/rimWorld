//
//  FoodInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/5.
//

import Foundation
import WCDBSwift

/// 食物组件
final class FoodInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var textureName: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = FoodInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
