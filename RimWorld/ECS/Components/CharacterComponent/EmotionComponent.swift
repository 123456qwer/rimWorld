//
//  EmotionComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import WCDBSwift

/// 心情组件
final class EmotionComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 总值
    var total: Double = 100
    /// 初始值
    var current: Double = 100
    /// 状态描述
    var status: String = "开心"
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = EmotionComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case total
        case current
        case status

        case componentID
        case entityID
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
