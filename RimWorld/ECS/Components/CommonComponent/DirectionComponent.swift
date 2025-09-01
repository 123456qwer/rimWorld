//
//  DirectionComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/14.
//

import Foundation
import WCDBSwift

final class DirectionComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 蓝图位置(例:朝向，默认朝下)
    var top: Bool = false
    var bottom: Bool = true
    var left : Bool = false
    var right: Bool = false
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = DirectionComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case top
        case bottom
        case left
        case right
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
