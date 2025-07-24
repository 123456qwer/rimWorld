//
//  MoveComponent.swift
//  RimWorld
//
//  Created by wu on 2025/6/6.
//

import Foundation
import WCDBSwift

/// 人物移动属性组件
final class MoveComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 寻路算法中需要走的位置
    var points:[CGPoint] = []
    
    /// 人物速度  单位： 格/tick  60 tick/s -> 1 * 1.2
    var speed:Double = 1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MoveComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case points
        case speed
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
