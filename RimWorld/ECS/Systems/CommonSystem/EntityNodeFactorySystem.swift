//
//  CreateNodeSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import Combine


/// 所有实体的参数都遵循这个协议
protocol EntityCreationParams {}

/// 蓝图参数
struct BlueprintParams: EntityCreationParams {
    let size: CGSize
    let materials: [String: Int]
    let type: BlueprintType
    let totalBuildPoint: Double
}

/// 存储区域参数
struct StorageParams: EntityCreationParams {
    let size: CGSize
}

/// 木头参数
struct WoodParams: EntityCreationParams {
    let woodCount: Int
}

/// 墙参数
struct WallParams: EntityCreationParams {
    /// 类型材质
    let material: MaterialType
    /// texture （直接传进来，省的在判断了）
    let wallTexture: String
    /// 类型
    let type: String
}


/// 创建Node的管理者
class EntityNodeFactorySystem: System {
    
    var ecsManager:ECSManager
    var cancellables = Set<AnyCancellable>()

    
    init(ecsManager: ECSManager) {
        self.ecsManager = ecsManager        
    }
    
    
    func createEntity(type: String,
                      point: CGPoint,
                      params: EntityCreationParams) {
        
        if type == kWood {
            createWood(point, params: params as! WoodParams)
        }else if type == kStorageArea{
            createSaveArea(point,params: params as! StorageParams)
        }else if type == kBlueprint {
            createBlueprint(point, params: params as! BlueprintParams)
        }else if type == kWoodWall {
            createWall(point, params: params as! WallParams)
        }
    }
    
    
    /// 创建木头
    func createWood(_ point:CGPoint,params: WoodParams) {
        
        let count = params.woodCount
        let entity = EntityFactory.shared.createWoodEntityWithoutSaving(point: point,params: params)
        createNodeAction(entity)
    }

    
    /// 创建墙
    func createWall(_ point: CGPoint, params: WallParams) {
        let entity = EntityFactory.shared.createWall(point: point, params: params)
        createNodeAction(entity)
    }
    
    /// 创建存储区域
    func createSaveArea(_ point:CGPoint, params: StorageParams) {
        let entity = EntityFactory.shared.createSaveAreaEntityWithoutSaving(point: point, params:params)
        createNodeAction(entity)
    }
    
    
    /// 创建建造蓝图
    func createBlueprint(_ point:CGPoint, params: BlueprintParams) {
        
        let material = params.materials
        let size = params.size
        let blueType = params.type
        let entity = EntityFactory.shared.createBlueprint(point: point,params: params)
        createNodeAction(entity)
    }
    
    
    
    
    
    /// 创建node和设置实体
    func createNodeAction(_ entity:RMEntity) {
        let nodeBuilder = NodeBuilder()
        entity.node = nodeBuilder.buildNode(for: entity)
        entity.node?.rmEntity = entity
        
        entity.node?.defaultXscale = entity.node?.xScale ?? 1
        entity.node?.defaultYscale = entity.node?.yScale ?? 1
        
        /// 创建完成，添加
        RMEventBus.shared.requestAddEntity(entity)
    }
}
