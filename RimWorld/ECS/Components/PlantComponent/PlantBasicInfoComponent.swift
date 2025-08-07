//
//  PlantBasicInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/6/4.
//

import Foundation
import WCDBSwift

final class PlantBasicInfoComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 植物纹理
    var plantTexture:String = ""
 

    
    /// 收货后可获得的最大数量
    var harvestYield:Int = 25
    /// 成熟度（设置成熟度到一定值后可以收获）
    var growthPercent:Float = 0.0
    
    /// 成长速度
    var growthSpeed:Float = 0.0001
    
    /// 砍伐生命值
    var cropHealth:Double = 100
    var cropCurrentHealth:Double = 100
    
    
    /// 采摘生命值
    var pickHealth:Double = 100
    var pickCurrentHealth:Double = 100
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PlantBasicInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case plantTexture
        
        case cropHealth
        case cropCurrentHealth
        
        case pickHealth
        case pickCurrentHealth
        
        case harvestYield
        case growthPercent
        case growthSpeed

    }
    
  
    
  
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}



