//
//  ComfortTemperatureComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import WCDBSwift

/// 温度
final class ComfortTemperatureComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 最低舒适温度（°C）
    var minComfortTemp: Double = 10.0
    /// 最高舒适温度（°C）
    var maxComfortTemp: Double = 30.0
    /// 最低可承受温度（°C）——低于这个温度会受伤或减益
    var minTolerableTemp: Double = -10.0
    /// 最高可承受温度（°C）——高于这个温度会受伤或减益
    var maxTolerableTemp: Double = 45.0
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ComfortTemperatureComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case minComfortTemp
        case maxComfortTemp
        case minTolerableTemp
        case maxTolerableTemp
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
