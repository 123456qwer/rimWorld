//
//  BlueprintComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import WCDBSwift

final class BlueprintComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var tileX: Int = 0
    var tileY: Int = 0
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    /// 蓝图位置(例:top + left 说明是左上连接点，这样判断) 
    var top: Bool = false
    var bottom: Bool = false
    var left : Bool = false
    var right: Bool = false
    
    /// 建筑用料 (默认木头)
    var materials: Int = MaterialType.wood.rawValue
   
    /// 蓝图坐标位置
    var key: TilePoint {
        TilePoint(x: tileX, y: tileY)
    }
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = BlueprintComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case tileX
        case tileY
        
        case width
        case height
        case top
        case bottom
        case left
        case right
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
