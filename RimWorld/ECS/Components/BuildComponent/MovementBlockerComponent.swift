//
//  MovementBlockerComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import WCDBSwift

final class MovementBlockerComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 具体不能行走的点
    var positions:[CGPoint] = []
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MovementBlockerComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case positions
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
