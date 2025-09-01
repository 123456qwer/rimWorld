//
//  BlueprintComponent.swift
//  RimWorld
//
//  Created by wu on 2025/7/24.
//

import Foundation
import WCDBSwift

final class BlueprintComponent: TableCodable, Component {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    var tileX: Int = 0
    var tileY: Int = 0
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    /// 锚点
    var anchorX:CGFloat = 0.5
    var anchorY:CGFloat = 0.5
    

    
    /// 蓝图对应的纹理
    var textureName: String = ""
    
    /// 建筑用料 (默认木头)(key = "\(MaterialType.type.rawValue)" MaterialType)
    var materials: [String:Int] = [:]
    /// 已经放入的材料
    var alreadyMaterials: [String: Int] = [:]
    
    /// 创建搬运任务，搬运的素材量，还未实装，搬运过程中
    var alreadyCreateHaulTask: [MaterialType:[Int: Int]] = [:]
    
    
    /// 蓝图类型
    var blueprintType: Int = BlueprintType.wall.rawValue
    
    /// 最终建造材质（如木头墙，石头墙，木头桌子，大理石桌子）
    var blueMaterial: Int = MaterialType.wood.rawValue
    
    /// 是否建造完成，建造完成，移除蓝图的时候，就不要把已有的数据删除了
    var isBuildFinish: Bool = false
    
    /// 总建造需要的点数
    var totalBuildPoints:Double = 100
    /// 当前建造的点数
    var currentBuildPoints:Double = 0
    
    /// 是否所需素材全部都有了
    var isMaterialCompelte = false
   
    /// 蓝图坐标位置
    var key: TilePoint {
        TilePoint(x: tileX, y: tileY)
    }
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = BlueprintComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        case tileX
        case tileY
        
        case width
        case height

 
        
        case materials
        case alreadyMaterials
        case blueprintType
        case totalBuildPoints
        case currentBuildPoints
        case isMaterialCompelte
        case textureName
        case anchorX
        case anchorY
        case blueMaterial
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}
