//
//  MiningComponent.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import WCDBSwift

/// 矿产资源
final class MiningComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 收货后可获得的最大数量
    var harvestYield:Int = 25
    
    /// 矿产纹理
    var miningTexture: String = ""
    
    /// 挖掘生命值
    var mineHealth:Double = 100
    var mineCurrentHealth:Double = 100
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MiningComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case harvestYield
        case miningTexture
        case mineHealth
        case mineCurrentHealth
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
