//
//  EventLogComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import WCDBSwift

struct InteractionLogEntry: Codable {
    let fromEntityID: Int
    let toEntityID: Int
    let content: String
    let timestamp: Int
    let emotion: InteractionEmotion
}

/// 社交事件组件
final class EventSocialLogComponent: TableCodable, Component {
    
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
        typealias Root = EventSocialLogComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case logsJson
//
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}



extension EventSocialLogComponent {
    
    /// 添加log
    func addLog(from: Int,
                to: Int,
                content: String,
                emotion: InteractionEmotion) {

        let date = Date()
        let timestamp = date.timeIntervalSince1970
        let log = InteractionLogEntry(fromEntityID: from, toEntityID: to, content: content, timestamp: Int(timestamp * 1000),emotion: emotion)
        logs.append(log)
        
    }
    
    
    
    
}
