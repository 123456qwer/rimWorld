//
//  StorageInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import Foundation
import WCDBSwift

/// 存储区域
final class StorageInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 存储等级
    var priority: Int = StoragePriority.normal.rawValue
    
    /// 当前格子上存储的实体
    var saveEntities:[Int:Int] = [:]
    

    var size:CGSize = CGSize(width: 0, height: 0)
    
    
    /// 允许存储的类型
    var allow:[String:[String:Bool]] = [
        
        textAction("Raw Meterial"):[textAction("Wood"):true],
        
        textAction("Raw Food"):[textAction("Apple"):true],
        
        textAction("Medicine"):[textAction("herbal"):true,
                          textAction("industrial"):true,
                          textAction("glitter"):true]
    ]
    
    
    
    /// 可存储的类型
    var canStorageType: [String: Bool] {
        var result: [String: Bool] = [:]
        for (_, subDict) in allow {
            for (key, value) in subDict {
                if value {
                    result[key] = true
                }
            }
        }
        return result
    }
  
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = StorageInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case priority
        case size
        case allow
        case saveEntities
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}


