//
//  LogComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/11.
//

import Foundation
import WCDBSwift

final class LogComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var name:String = ""
    var log: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = LogComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case name
        case log
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
