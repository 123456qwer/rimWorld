//
//  HaulableComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/4.
//


import Foundation
import WCDBSwift

/// 可搬运的物体所携带的组件
final class HaulableComponent: TableCodable, Component {
    
    /// 重量
    var weight: Double = 0.6
    
    /// 最大堆叠数量
    var stackLimit:Int = 75
    
    /// 当前堆叠数量
    var currentCount: Int = 0
    
    /// 是否正在被搬运
    var isHauled: Bool = false
    
    /// 原材料
    var materialType: Int = MaterialType.wood.rawValue
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = HaulableComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case weight
        case isHauled
        case currentCount
        case stackLimit
        case materialType
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
