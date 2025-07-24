//
//  OutDoorComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import WCDBSwift

final class OutdoorComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 外出
    var outDoor:Int = 100
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = OutdoorComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case outDoor
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
