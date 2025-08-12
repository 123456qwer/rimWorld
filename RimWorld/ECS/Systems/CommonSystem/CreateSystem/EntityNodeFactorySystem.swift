//
//  CreateNodeSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import Combine

/// 统一创建协议
protocol EntityCreator {
    func create(point: CGPoint, params: EntityCreationParams) -> RMEntity
}

/// 泛型Creator
class GenericEntityCreator<Params: EntityCreationParams>: EntityCreator {
    
    private let createBlock: (CGPoint, Params) -> RMEntity
    

    
    init(createBlock: @escaping (CGPoint, Params) -> RMEntity) {
        self.createBlock = createBlock
    }
    
    func create(point: CGPoint, params: any EntityCreationParams) -> RMEntity {
        guard params is Params else {
            fatalError("参数类型不匹配: \(Params.self)")
        }
        return createBlock(point, params as! Params)
    }
}





/// 创建Node的管理者
class EntityNodeFactorySystem: System {
    
    var ecsManager:ECSManager
    let provider: PathfindingProvider
    var cancellables = Set<AnyCancellable>()

    private var creators: [String: EntityCreator] = [:]
    
    init(ecsManager: ECSManager, provider: PathfindingProvider) {
        self.ecsManager = ecsManager
        self.provider = provider
        registerDefaults()
    }
    
    
    func register<T: EntityCreationParams>(type: String, creator: @escaping (CGPoint, T) -> RMEntity) {
        let wrapped = GenericEntityCreator<T>(createBlock: creator)
        creators[type] = wrapped
    }
    
    
    private func registerDefaults() {
        
        // Swift 允许省略 return 关键字，当闭包体是一个单表达式的时候。
        /// 木头
        register(type: kWood) { [weak self] point, params in
            EntityFactory.shared.createWoodEntityWithoutSaving(point: point, params: params, ecsManager: self!.ecsManager)
        }
        
        /// 矿石
        register(type: kOre) {[weak self] point, params in
            EntityFactory.shared.createOreEntityWithoutSaving(point: point, params: params, ecsManager: self!.ecsManager)
        }

        /// 存储区域
        register(type: kStorageArea) { point, params in
            EntityFactory.shared.createSaveAreaEntityWithoutSaving(point: point, params: params)
        }

        /// 蓝图
        register(type: kBlueprint) { point, params in
            EntityFactory.shared.createBlueprint(point: point, params: params)
        }

        /// 木墙
        register(type: kWoodWall) { [weak self] point, params in
            EntityFactory.shared.createWall(point: point, params: params, provider: self!.provider)
        }

        /// 种植区域
        register(type: kGrowingArea) { point, params in
            EntityFactory.shared.createGrowingArea(point: point, params: params)
        }

        /// 水稻
        register(type: kRice) { [weak self] point, params in
            EntityFactory.shared.createRice(point: point, params: params, ecsManager: self!.ecsManager)
        }
        
        /// 砍伐的斧头
        register(type: kAX) { [weak self] point, params in
            EntityFactory.shared.createAX(point: point, params: params, ecsManager: self!.ecsManager)
        }
        
        /// 挖掘的镐子
        register(type: kPickaxe) {[weak self] point, params in
            EntityFactory.shared.createMine(point: point, params: params, ecsManager: self!.ecsManager)
        }
        
        /// 采摘的手
        register(type: kPickHand) {[weak self] point, params in
            EntityFactory.shared.createHand(point: point, params: params, ecsManager: self!.ecsManager)
        }
    }
    
    
    func createEntity(type: String,
                      point: CGPoint,
                      params: EntityCreationParams) {
        
        guard let creator = creators[type] else {
            ECSLogger.log("未注册的类型：\(type) 💀💀💀")
            return
        }
        
        let entity = creator.create(point: point, params: params)
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
