//
//  OwnershipComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
import WCDBSwift

/// 所拥有的组件
final class OwnershipComponent: TableCodable, Component {
    
    var entityID:Int = -1
    
    var componentID:Int = -1
    
    /// 存储拥有的实例 如1,2,3
    var ownedEntityIDsString: String = ""
    /// 实际使用转换成数组
    var ownedEntityIDS: [Int] {
        get {
            return ownedEntityIDsString.split(separator: ",").compactMap{  Int($0)
            }
        }
        set {
            ownedEntityIDsString = newValue.map{ String($0) }.joined(separator: ",")
        }
    }
    
    
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = OwnershipComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true, isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case ownedEntityIDsString
    }
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
}
