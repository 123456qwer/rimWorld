//
//  GrowInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation
import WCDBSwift

final class GrowInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var size:CGSize = CGSize(width: 0, height: 0)
    
    /// 当前格子上存储的实体
    var saveEntities:[Int:Int] = [:]

    var cropType: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = GrowInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case size
        case cropType
        case saveEntities
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
