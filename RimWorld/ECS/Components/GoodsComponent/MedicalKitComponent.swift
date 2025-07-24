//
//  MedicalKitComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/16.
//

import Foundation
import WCDBSwift

final class MedicalKitComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 当前医疗包的品质类型
    var quality: String = MedicalQuality.herbal.rawValue
    
    /// 身上带的数量
    var medicineCount:Int = 3

    /// 药品重量（kg）
    var weight:Double = 0.5
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MedicalKitComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case quality
        case weight
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
