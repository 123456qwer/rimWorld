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
    /// 是否可以砍伐
    var canChop:Bool = false
    /// 是否正在被人砍伐
    var choppedEntityID = 0

    /// 收货后可获得的最大数量
    var harvestYield:Int = 25
    /// 成熟度
    var growthPercent:Float = 0.5
    
    /// 成长速度
    var growthSpeed:Float = 0.001
    
    /// 砍伐生命值
    var health:Double = 100
    var currentHealth:Double = 100
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PlantBasicInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case plantTexture
        
        case health
        case currentHealth
        case canChop
        case harvestYield
        case growthPercent
        case growthSpeed

    }
    
  
    
  
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}



