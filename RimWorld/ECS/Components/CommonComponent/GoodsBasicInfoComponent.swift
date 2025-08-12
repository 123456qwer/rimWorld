//
//  GoodsBasicInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import WCDBSwift

/// 物体通用基础组件
final class GoodsBasicInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 纹理名称
    var textureName:String = ""
    
    /// 最大耐久度
    var maxDurability: Int = 100
    
    /// 当前耐久度
    var currentDurability: Int = 100
    

    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = GoodsBasicInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case textureName
        case maxDurability
        case currentDurability
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
