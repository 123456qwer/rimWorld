//
//  TraitComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/12.
//

import Foundation
import WCDBSwift

/// 人物特性，如健步如飞
final class TraitComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 特性拼串,CharacterTrait，如1,2,3,4 = optimist,pessimist,pyromaniac,nimble
    var traits: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TraitComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case traits
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
    
    /// 拼接
    func addTraits(_ traitsIds:[Int]) {
        for id in traitsIds {
            traits.append("\(id),")
        }
        traits.removeLast()
    }
}
