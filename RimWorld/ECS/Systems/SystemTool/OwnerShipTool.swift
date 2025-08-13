//
//  OwnerShipTool.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

//MARK: - 🚩 所属关系工具类 🚩 -
/// 所属关系工具类
struct OwnerShipTool {
    
    /// 处理关联关系改变的逻辑方法
    static func handleOwnershipChange(newOwner: RMEntity,
                                         owned: RMEntity,
                                    ecsManager: ECSManager){
        
        /// 存储区域重置
        if newOwner.type == kStorageArea {
            reloadStorage(owner: newOwner,
                           owned: owned,
                           ecsManager: ecsManager)
            return
        }
        
        
        /// 普通重置
        OwnerShipTool.assignOwner(owner: newOwner, owned: owned, ecsManager: ecsManager)
    }
    
    
    /// 处理关联关系改变，从仓库中移除或减少
    static func detachFromStorage(storage: RMEntity,
                                  owned: RMEntity,
                                  lastCount: Int,
                                  ecsManager: ECSManager){
        
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            ECSLogger.log("此存储区域没有基础存储控件！💀💀💀")
            return
        }
        
        let allKeys = getStorageAllKeys(storage: storage)
        var allSaveEntities = storageComponent.saveEntities
        
        for index in allKeys {
            let entityID = allSaveEntities[index]
            ///
            if entityID == owned.entityID {
                
                /// 如果剩余为0，说明全部取走，直接置空就好了
                if lastCount == 0 {
                    storageComponent.saveEntities[index] = nil
                    return
                }else {
                    
                    /// 如果还有剩余，创建对应的实体，并放入到仓库中
                    var params:EntityCreationParams?
                    if owned.type == kWood {
                        params = HarvestParams(harvestCount: lastCount,
                                            superEntity: storage.entityID,
                                            saveIndex: index)
                        
                    }
                    
                    /// 创建对应剩余实体
                    let point = PositionTool.nowPosition(owned)
                    RMEventBus.shared.requestCreateEntity(type: owned.type,
                                                          point: point,
                                                          params: params!)
                    
                }
                
            }
            
        }
        
    }
    
    
    /// 将 `owned` 实体设置为由 `owner` 拥有
    private static func assignOwner(owner: RMEntity,
                                    owned: RMEntity,
                                    ecsManager:ECSManager) {
        
        
        let beOwnerComponent = owned.getComponent(ofType: OwnedComponent.self) ?? OwnedComponent()
        /// 先删除之前的依赖
        removeOwner(owned: owned, ecsManager: ecsManager)
        
        beOwnerComponent.entityID = owned.entityID
        beOwnerComponent.ownedEntityID = owner.entityID
        
        owned.addComponent(beOwnerComponent)
        
        /// 拥有者队列里新增entityID
        addOwned(owner: owner, owned: owned)
        
        /// 搬运人负重
        guard let carryComponent = owner.getComponent(ofType: CarryingCapacityComponent.self) else {
            return
        }
        /// 搬运的物体负重
        guard let ownedHaulComponent = owned.getComponent(ofType: HaulableComponent.self) else {
            return
        }
        
        carryComponent.currentLoad += (ownedHaulComponent.weight * Double(ownedHaulComponent.currentCount))
    }
    
    
    /// 删除之前的依赖实体
    static func removeOwner(owned: RMEntity,
                            ecsManager:ECSManager){
        
        let beOwnerComponent = owned.getComponent(ofType: OwnedComponent.self) ?? OwnedComponent()
        
        guard let owner = ecsManager.getEntity(beOwnerComponent.ownedEntityID),
              let ownerShipComponent = owner.getComponent(ofType: OwnershipComponent.self) else {
            ECSLogger.log("当前实体没有依赖者哦！")
            return
        }
        
      
        if let index = ownerShipComponent.ownedEntityIDS.firstIndex(where: {
            $0 == owned.entityID
        }){
            ownerShipComponent.ownedEntityIDS.remove(at: index)
        }
        
        /// 搬运人负重
        guard let carryComponent = owner.getComponent(ofType: CarryingCapacityComponent.self) else {
            return
        }
        /// 搬运的物体负重
        guard let ownedHaulComponent = owned.getComponent(ofType: HaulableComponent.self) else {
            return
        }
        
        carryComponent.currentLoad -= (ownedHaulComponent.weight * Double(ownedHaulComponent.currentCount))
        
    }
    
    /// 删除之前的依赖实体(初始化)
    static func removeOwner(owned: RMEntity,
                            owner: RMEntity){
        
        let beOwnerComponent = owned.getComponent(ofType: OwnedComponent.self) ?? OwnedComponent()
        
        guard let ownerShipComponent = owner.getComponent(ofType: OwnershipComponent.self) else {
            ECSLogger.log("当前实体没有依赖者哦！")
            return
        }
        
      
        if let index = ownerShipComponent.ownedEntityIDS.firstIndex(where: {
            $0 == owned.entityID
        }){
            ownerShipComponent.ownedEntityIDS.remove(at: index)
        }
        
        /// 搬运人负重
        guard let carryComponent = owner.getComponent(ofType: CarryingCapacityComponent.self) else {
            return
        }
        /// 搬运的物体负重
        guard let ownedHaulComponent = owned.getComponent(ofType: HaulableComponent.self) else {
            return
        }
        
        carryComponent.currentLoad -= (ownedHaulComponent.weight * Double(ownedHaulComponent.currentCount))
        
    }


    
    /// 设置拥有者的entityID队列
    private static func addOwned(owner: RMEntity,
                                 owned: RMEntity) {
        
        let onwerShipComponent = owner.getComponent(ofType: OwnershipComponent.self) ?? OwnershipComponent()
        
        /// 新增
        onwerShipComponent.ownedEntityIDS.append(owned.entityID)
        owner.addComponent(onwerShipComponent)
    }
    
    /// 所有key
    private static func getStorageAllKeys(storage: RMEntity) -> [Int] {
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            ECSLogger.log("此存储区域没有基础存储控件！💀💀💀")
            return []
        }
        
        let size = storageComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        var keys:[Int] = []
        for index in 0..<totalTiles {
            keys.append(index)
        }
        
        return keys
    }
    
 
    /// 重载存储区域
    private static func reloadStorage(owner: RMEntity,
                              owned: RMEntity,
                        ecsManager: ECSManager) {
        
        guard let saveComponent = owner.getComponent(ofType: StorageInfoComponent.self) else {
            ECSLogger.log("此存储区域没有基础存储控件！💀💀💀")
            return
        }
        guard let ownedHaulComponent = owned.getComponent(ofType: HaulableComponent.self) else {
            ECSLogger.log("此待存储的实体没有搬运控件！💀💀💀")
            return
        }
        
        /// 重置实体关系（需要放到前边，否则称重会变动，产生问题）
        OwnerShipTool.assignOwner(owner: owner, owned: owned, ecsManager: ecsManager)
        
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        /// 当前格子上存储的实体
        let saveEntities = saveComponent.saveEntities
        
        /// 存储的位置
        var selectIndex = 0
        var ownedPoint = CGPoint(x: 0, y: 0)
        /// 遍历格子
        for index in 0..<totalTiles {
            
            /// 存储的实体
            if let saveEntity = ecsManager.getEntity(saveEntities[index] ?? -1) {
                /// 存储类型相同
                if saveEntity.type == owned.type {
                    
                    guard let saveComponent = saveEntity.getComponent(ofType: HaulableComponent.self) else { continue }
                    /// 最大存储
                    let maxLimit = saveComponent.stackLimit
                    /// 当前存储
                    let current = saveComponent.currentCount
                    /// 存满了，直接下一个栏位
                    if maxLimit == current { continue }
                    
                    /// 存入的数量
                    let ownedCurrent = ownedHaulComponent.currentCount
                    
                    /// 如果当前存入量 + 现在要存入的量 < 总量
                    if ownedCurrent + current <= maxLimit {
                        
                        /// 直接删除当前存入的，叠加进之前的存储模块中
                        ecsManager.removeEntity(owned)
                        saveComponent.currentCount = ownedCurrent + current
                        
                        /// 更新存储数字
                        ecsManager.reloadNodeNumber(saveEntity)
                        
                        return
                        
                    }else {
                        /// 溢出
                        /// 之前的仓库存满
                        saveComponent.currentCount = maxLimit
                        /// 更新存储数字
                        ecsManager.reloadNodeNumber(saveEntity)
                        
                        /// 新的
                        ownedHaulComponent.currentCount = ownedCurrent + current - maxLimit
                        
                        /// 更新存储数字
                        ecsManager.reloadNodeNumber(owned)
                        
                        continue
                    }
                    
                } else {
                    /// 不同类型不能存
                    continue
                }
            }

            /// 如果走到这里，说明是空格子
            selectIndex = index
            
            let col = index % cols
            let row = index / cols

            let x = CGFloat(col) * tileSize + 16.0
            let y = CGFloat(row) * -tileSize - 16.0
            ownedPoint = CGPoint(x: x, y: y)
            
            break
        }
        
        /// 存储实体
        saveComponent.saveEntities[selectIndex] = owned.entityID
        /// 重置实体的位置
        PositionTool.setPosition(entity: owned, point: ownedPoint)
        /// 替换父类实体
        RMEventBus.shared.requestReparentEntity(entity: owned, z: 10, point: ownedPoint)
        
    }
    
    
}
