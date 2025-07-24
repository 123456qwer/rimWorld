//
//  BasicInfoComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift

/// 角色基础组件
final class BasicInfoComponent: Component,TableCodable, Codable {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /// 性别
    var gender:Int = 1
    /// 年龄
    var age:Int = 10
    /// 昵称
    var nickName:String = ""
    /// 名
    var firstName:String = ""
    /// 姓
    var lastName:String = ""
    /// 称号
    var title:String = ""
    /// 职位
    var roleTitle:String = textAction("未分配职位")
    /// 种族（SpeciesType）
    var race:Int = SpeciesType.human.rawValue
    /// 唯一标识，用于初始化
    var keyName:String = ""
    /// 纹理
    var textureName:String = ""
   
    /// 排序，默认0是无排序
    var playerSetIndex:Int = 0
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = BasicInfoComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID,isPrimary: true,isAutoIncrement: false)
        }
      
        case race
        case componentID
        case entityID
        case gender
        case age 
        case nickName
        case firstName
        case lastName
        case title
        case roleTitle
        case keyName
        case playerSetIndex
        case textureName
    }
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
    
    
}


