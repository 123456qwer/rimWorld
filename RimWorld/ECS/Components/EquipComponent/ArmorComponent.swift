//
//  ArmorComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import WCDBSwift

final class ArmorComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 名称
    var textureName:String = "WitchArmor_icon"
    /// 评级
    var level:Int = 1

    /// 重量（kg）
    var weight:Double = 6.0
    /// 耐久度
    var durability: Int = 100
    
    /// 对利器的护甲值（%）
    var sharpArmor: Double = 12.0

    /// 对钝器的护甲值（%）
    var bluntArmor: Double = 12.0

    /// 对热能的护甲值（%）
    var heatArmor: Double = 13.0
    
    
    /// 提供的最低温度保护修正（°C）
    var minTemperatureBonus: Double = -10.0

    /// 提供的最高温度保护修正（°C）
    var maxTemperatureBonus: Double = 5.0
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ArmorComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case textureName
        case level
        case weight
        case durability
        case minTemperatureBonus
        case maxTemperatureBonus
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
    
    /// 评级
    func getWeaponLevel() -> String {
        let quality = RimWorldEntityQuality(rawValue: level)
        return textAction(quality!.englishName)
    }
}
