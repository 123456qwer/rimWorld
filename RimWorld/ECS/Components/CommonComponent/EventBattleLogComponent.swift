//
//  EventBattleLogComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import WCDBSwift

/// 战斗事件组件
final class EventBattleLogComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// json存储
    var logsJson: String = "[]"
    var logs:[InteractionLogEntry] {
        get {
            if let data = logsJson.data(using: .utf8),
               let array = try? JSONDecoder().decode([InteractionLogEntry].self, from: data){
                return array
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let jsonString = String(data: data, encoding: .utf8) {
                logsJson = jsonString
            }
        }
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = EventBattleLogComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case logsJson

    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
