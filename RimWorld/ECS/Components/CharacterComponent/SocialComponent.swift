//
//  SocialComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import WCDBSwift

/// 社交
final class SocialComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    /// 社交关系JSON
    var relationshipJSON: String = "{}"
    /// 社交关系
    var relationship:[Int:String] {
        get {
            if let data = relationshipJSON.data(using: .utf8),let dict = try? JSONDecoder().decode([Int: String].self, from:data){
                return dict
            }
            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),let jsonString = String(data: data, encoding: .utf8) {
                relationshipJSON = jsonString
            }
        }
    }
    
    

    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = SocialComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case relationshipJSON

    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
    
    lazy var nameMehtodMap: [String: () -> Void] = [kMichaelJordan: MichaelJordan,
                                                           kYueFei:YueFei]
}


/// 获取当前关系下评分
extension SocialComponent {
    /// 根据亲密关系评分
    func getScore(_ relationship: RelationshipType) -> Int {
        switch relationship {
        case .stranger:
            return 0
        case .acquaintance:
            return 10
        case .friend:
            return 30
        case .closeFriend:
            return 50
        case .lover:
            return 70
        case .spouse:
            return 90
        case .exLover:
            return -20
        case .parent:
            return 80
        case .child:
            return 80
        case .sibling:
            return 60
        case .relative:
            return 40
        case .leader:
            return 30
        case .subordinate:
            return 20
        case .enemy:
            return -70
        case .rival:
            return -40
        case .admired:
            return 50
        case .despised:
            return -50
        }
    }
}


/// 初始化方法
extension SocialComponent {
    
    /// 根据名字
    func initDataForName(_ keyName: String){
        nameMehtodMap[keyName]?()
    }
    
    /// 迈克尔乔丹
    func MichaelJordan(){
        
    }
    
    /// 岳飞
    func YueFei(){
        
    }
}
