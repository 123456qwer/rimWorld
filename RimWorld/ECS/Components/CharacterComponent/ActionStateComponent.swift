//
//  ActionStateComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/10.
//

import Foundation
import WCDBSwift

/// 行为组件
final class ActionStateComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1

    /// 当前正在做的事情
    var actions:[String] = []
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ActionStateComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
    
    /// 行为描述
    func getActionType() -> String {
        return actions.last ?? textAction("idle")
    }
}
