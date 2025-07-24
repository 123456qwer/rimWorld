//
//  AllEntityData.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
import WCDBSwift

/// 存储所有实体
final class EntityData:TableCodable {
    
    /// 当前实体Id
    var entityID:Int = -1
    var ownerID:String = ""
    /// 当前实体表名
    var tableName:String = ""
    /// 类型 -> character, weapon
    var type:String = ""
    /// 实体名称
    var name:String = ""
    /// 此data的数据应为: {"allComponent":["BasicInfoComponent":Data()]}
    var data:Data = Data()
    
    enum CodingKeys:String, CodingTableKey {
        typealias Root = EntityData
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(entityID, isPrimary: true, isAutoIncrement: false)
        }
        case entityID
        case tableName
        case type
        case data
        case name   
    }
    
}
