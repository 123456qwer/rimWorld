//
//  EquipComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift

/// 武器模块
final class WeaponComponent: TableCodable, Component, Codable {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 武器名称
    var textureName:String = ""
    /// 评级
    var level:Int = 1
    
    /// 武器提供的攻击力
    var atk:Int = 1
    /// 攻击范围
    var range:Int = 1
    /// 武器重量（kg）
    var weight:Double = 4.0
    /// 耐久度
    var durability: Int = 100


    
    enum CodingKeys: String, CodingTableKey{
        typealias Root = WeaponComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case entityID
        case componentID
        case textureName
        case atk
        case range
        case level
        case weight
        case durability
    }
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
    
    /// 武器评级
    func getWeaponLevel() -> String {
        let quality = RimWorldEntityQuality(rawValue: level)
        return textAction(quality!.englishName) 
    }
    
}
