//
//  WallComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/25.
//

import Foundation
import WCDBSwift

final class WallComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 总耐久度
    var totalHealth: Double = 100
    /// 当前耐久度
    var currentHealth: Double = 100
    /// 纹理
    var textureName: String = ""
    
    var width: Double = tileSize
    var height: Double = tileSize

    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WallComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case totalHealth
        case currentHealth
        case textureName
        case width
        case height
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
