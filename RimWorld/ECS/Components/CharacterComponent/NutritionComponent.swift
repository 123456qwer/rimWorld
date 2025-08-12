//
//  NutritionComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import WCDBSwift

/// 饮食、营养
final class NutritionComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var total:Double = 100
    var current:Double = 100
    var threshold:Double = 25
    
    /// 每次减少的饥饿值
    var nutritionDecayPerTick:Double = 0.1
 
    /// 是否创建了对应任务
    var isCreateTask:Bool = false
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = NutritionComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case total
        case current
        case nutritionDecayPerTick
        case threshold
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
