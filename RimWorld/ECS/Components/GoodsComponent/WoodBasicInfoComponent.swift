//
//  WoodBasicInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/6/30.
//

import Foundation
import WCDBSwift

final class WoodBasicInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var woodTexture:String = ""


    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WoodBasicInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        
        case woodTexture

    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
