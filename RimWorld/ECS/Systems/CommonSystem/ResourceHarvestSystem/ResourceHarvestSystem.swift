//
//  ResourceHarvestSystem.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 统一创建协议
protocol EntityRemoveCreator {
    func remove(params: RemoveReason) -> Void
}

class GenericEntityRemoveCreator<Params: RemoveReason>: EntityRemoveCreator {
    private let removeBlock:(Params) -> Void
    
    init(removeBlock: @escaping (Params) -> Void) {
        self.removeBlock = removeBlock
    }
    
    func remove(params: any RemoveReason) -> Void {
        guard params is Params else {
            fatalError("参数类型不匹配: \(Params.self)")
        }
        return removeBlock(params as! Params)
    }
    
}



/// 资源收割类型
class ResourceHarvestSystem: System {
    
    let ecsManager: ECSManager
    
    private var creators: [String : EntityRemoveCreator] = [:]
    
    init (ecsManager: ECSManager) {
        self.ecsManager = ecsManager
        registerDefaults()
    }
    
    func register<T: RemoveReason>(type: String, creator: @escaping (T) -> Void) {
        let wrapped = GenericEntityRemoveCreator<T>(removeBlock:creator)
        creators[type] = wrapped
    }
    
    
    private func registerDefaults() {
        
        /// 移除树（砍伐）
        register(type: kTree) {[weak self] (params: TreeRemoveReason) in
            self!.removePlant(params: params)
        }
        
        /// 移除树苹果树（砍伐）
        register(type: kAppleTree) {[weak self] (params: TreeRemoveReason) in
            self!.removePlant(params: params)
        }
        
        /// 移除树上的苹果
        register(type: kApple) { [weak self] (params: PickRemoveReason) in
            self!.removeApple(params: params)
        }
        
        /// 移除矿石
        register(type: kStone) { [weak self] (params: MineRemoveReason) in
            self!.removeMine(params: params)
        }
        
        /// 移除存储区域
        register(type: kStorageArea) { [weak self] (params: StorageRemoveReason) in
            self!.removeStorage(reason: params)
        }
        
        /// 移除蓝图
        register(type: kBlueprint) { [weak self] (params: BlueprintRemoveReason) in
            self!.removeBlueprint(reason: params)
        }
        
        /// 移除种植区域
        register(type: kGrowingArea) { [weak self] (params: GrowingAreaRemoveReason) in
            self!.removeGrowing(reason: params)
        }
        
        
    }
    
    
    
    /// 移除实体，生成对应的需要实体（比如移除树，生成木头）
    func handleRemovalAndHarvestCreation(entity: RMEntity,
                                         reason: RemoveReason?){
        

        guard let reason = reason else {
            return 
        }
        guard let creator = creators[entity.type] else {
            ECSLogger.log("未注册的类型：\(entity.type) 💀💀💀")
            return
        }
        
        
        creator.remove(params: reason)
    }
    
}
