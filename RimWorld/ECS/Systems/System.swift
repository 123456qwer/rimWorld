//
//  System.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

/// 协议 System
import Foundation
import SpriteKit

protocol System: AnyObject {
    
}

//MARK: - 🚩 坐标工具类 🚩 -
struct PositionTool {
    
    /// 当前实体坐标
    static func nowPosition(_ entity: RMEntity) -> CGPoint {
        guard let pos = entity.getComponent(ofType: PositionComponent.self) else {
            return .zero
        }
        return CGPoint(x: pos.x, y: pos.y)
    }
    
    /// 当前实体在scene上的坐标
    static func nowPositionForScene(_ entity: RMEntity,
                                    provider: PathfindingProvider) -> CGPoint {
        return provider.pointFromScene(entity)
    }
    
    /// 实体数组排序，按距离由近到远
    static func sortEntityForDistance(entity: RMEntity, entities:[RMEntity]) -> [RMEntity] {
        
        let targetPos = PositionTool.nowPosition(entity)
        
        return entities.sorted {
            let pos1 = PositionTool.nowPosition($0)
            let pos2 = PositionTool.nowPosition($1)
            let dis1 = MathUtils.distance(targetPos, pos1)
            let dis2 = MathUtils.distance(targetPos, pos2)
            return dis1 < dis2
        }
    }
    
    /// 按需求排序，需求量最小的优先
    /// 按照对目标材料的需求量（越少越优先）对蓝图排序
    static func sortBlueprintEntitiesByNeed(targetEntity: RMEntity,
                                            blueprintEntities: [RMEntity]) -> [RMEntity] {
        
        let materialType = EntityInfoTool.materialType(targetEntity)
        let key = "\(materialType.rawValue)"
        
        func needCount(for blueprint: RMEntity) -> Int {
            guard let blueprintComp = blueprint.getComponent(ofType: BlueprintComponent.self) else {
                return Int.max
            }
            
            let maxNeed = blueprintComp.materials[key] ?? 0
            let already = blueprintComp.alreadyMaterials[key] ?? 0
            let hauling = blueprintComp.alreadyCreateHaulTask[materialType]?.values.reduce(0, +) ?? 0
            
            return max(0, maxNeed - already - hauling)
        }
        
        return blueprintEntities.sorted {
            needCount(for: $0) < needCount(for: $1)
        }
    }

    
    /// 设置当前实体坐标
    static func setPosition( entity: RMEntity,
                             point: CGPoint) {
        guard let pointComponent = entity.getComponent(ofType: PositionComponent.self) else { return }
        pointComponent.x = point.x
        pointComponent.y = point.y
        entity.node?.position = point
    }
    
    /// 当前存储实体空余的坐标
    static func saveAreaEmptyPosition( saveArea: RMEntity) -> CGPoint{
        
        guard let saveComponent = saveArea.getComponent(ofType: StorageInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
        
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                let col = index % cols
                let row = index / cols

                let x = CGFloat(col) * tileSize + 16.0
                let y = CGFloat(row) * -tileSize - 16.0
                return CGPoint(x: x, y: y)
            }
        }
        
        
        return .zero
    }
    
    
    /// 根据size获取区域的所有坐标点
    static func getAreaAllPoints(size: CGSize) -> [CGPoint] {
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        var points:[CGPoint] = []
        for index in 0..<totalTiles {
            let col = index % cols
            let row = index / cols

            let x = CGFloat(col) * tileSize + 16.0
            let y = CGFloat(row) * -tileSize - 16.0
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    /// 根据Index获取位置
    static func growAreaCropPoint(area: RMEntity, key: Int) -> CGPoint {
        guard let saveComponent = area.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        var points:[CGPoint] = []
        for index in 0..<totalTiles {
            let col = index % cols
            let row = index / cols

            let x = CGFloat(col) * tileSize + 16.0
            let y = CGFloat(row) * -tileSize - 16.0
            points.append(CGPoint(x: x, y: y))
        }

        if key < points.count {
            return points[key]
        }else {
            return .zero
        }
    }
    
    /// 当前存储实体空余的坐标
    static func growAreaEmptyPosition( saveArea: RMEntity) -> CGPoint {
        
        guard let saveComponent = saveArea.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return .zero
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
        
        /// 空闲位置
        var point = CGPoint(x: 0, y: 0)
        
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                let col = index % cols
                let row = index / cols

                let x = CGFloat(col) * tileSize + 16.0
                let y = CGFloat(row) * -tileSize - 16.0
                point = CGPoint(x: x, y: y)
                break
            }
        }
        
        /// 转换成实际位置
        let savePoint = PositionTool.nowPosition(saveArea)
        let returnPoint = CGPoint(x: savePoint.x + point.x, y: savePoint.y + point.y)
        
        
        return returnPoint
    }
    
    /// 种植空闲的位置
    static func growAreaEmptyIndex( saveArea: RMEntity) -> Int {
        guard let saveComponent = saveArea.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("获取存储实体空余坐标时，此存储区域没有基础存储控件！💀💀💀")
            return 0
        }
        
        let size = saveComponent.size
        
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        // 存储区域总格子数
        let totalTiles = abs(cols * rows)
        
        let saveEntities = saveComponent.saveEntities
    
        /// 返回空余空间
        for index in 0..<totalTiles {
            if saveEntities[index] != nil {
                return index
            }
        }
        
        return 0
    }
    
}


//MARK: - 🚩 所属关系工具类 🚩 -
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
                        params = WoodParams(woodCount: lastCount,
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


//MARK: - 🚩 用于判断实体是否具有某些能力的工具类 🚩 -
/// 用于判断实体是否具有某些能力的工具类
struct EntityAbilityTool {
    
    /// 是否可以割除
    static func ableCutting(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.cutting > 0 {
                return true
            }
        }
        return false
    }
    
    /// 是否可以搬运
    static func ableHauling(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.hauling > 0 {
                return true
            }
        }
        return false
    }
    
    /// 是否可以建造
    static func ableBuild(_ entity: RMEntity) -> Bool {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            if workComponent.building > 0 {
                return true
            }
        }
        return false
    }
    
    /// 可以存储的实体
    static func ableToSaving(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: StorageInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 是否能执行休息任务的实体
    static func ableToRest(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: EnergyComponent.self) != nil {
            return true
        }
        return false
    }
    
    static func isRestingNow(_ entity: RMEntity) -> Bool {
        guard let restComponent = entity.getComponent(ofType: EnergyComponent.self) else {
            return false
        }
        return restComponent.isResting
    }
   
    /// 可以被砍伐的实体
    static func ableToBeCut(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: PlantBasicInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 判断实体是否可以被搬运
    static func ableToBeHaul(_ entity: RMEntity,
                             _ ecsManager: ECSManager) -> Bool {
        
        /// 搬运组件
        guard entity.getComponent(ofType: HaulableComponent.self) != nil else {
            return false
        }

        /// 可搬运物体，如果在非仓库的情况下，不能再次被搬运(后续在看有别的变化没)
        if let owned = entity.getComponent(ofType: OwnedComponent.self),
           let ownerEntity = ecsManager.getEntity(owned.ownedEntityID),
           ownerEntity.type != kStorageArea {
            return false
        }

        return true
    }
    
    /// 可以成长的植物
    static func ableToPlantGrowth(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: PlantBasicInfoComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 可以执行任务的实体
    static func ableToTask(_ entity: RMEntity) -> Bool {
        if entity.getComponent(ofType: TaskQueueComponent.self) != nil {
            return true
        }
        return false
    }
    
    /// 是否可以存储当前元素
    static func ableToStorage(storage: RMEntity,material: RMEntity) -> Bool {
        
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            return false
        }
        
        return storageComponent.canStorageType[textAction(material.type)] ?? false
        
    }
    
    
    /// 蓝图，可被建造的实体
    static func ableToBeBuild(_ entity: RMEntity) -> BlueprintComponent? {
        if let component = entity.getComponent(ofType: BlueprintComponent.self) {
            return component
        }
        return nil
    }
    
    /// 种植区域，可被种植的实体
    static func ableToBeGrow(_ entity: RMEntity) -> Bool {
        guard let growComponent = entity.getComponent(ofType: GrowInfoComponent.self) else {
            return false
        }
        return true
    }
    
    /// 可执行吃饭任务
    static func ableToEat(_ entity: RMEntity) -> Bool {
        guard let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self) else {
            return false
        }
        return true
    }
  
    
    /// 素材材料等
    static func ableToBeMaterial(_ entity: RMEntity) -> CategorizationComponent? {
        if let component = entity.getComponent(ofType: CategorizationComponent.self) {
            return component
        }
        return nil
    }
    
    /// 是否可以强制替换任务
    static func ableForceSwitchTask(entity: RMEntity,
                            task: WorkTask) -> Bool{
        
        guard entity.getComponent(ofType: WorkPriorityComponent.self) != nil else {
            return false
        }
        
        /// 没有任务，直接替换
        guard let currentTask = EntityInfoTool.currentTask(entity) else {
            return true
        }
        
        let currentType = currentTask.type
        let useCurrentType = currentTask.type
        
        let newType = task.type
        let useNewType = task.type
        
        /// 任务类型完全相同，不能替换
        if useCurrentType == useNewType {
            return false
        }
        
        /// 当前正在休息中，不可替换（除非未来支持玩家强制替换）
        if currentTask.type == .Rest {
            return false
        }
        
        /// 当前任务等级
        let currentTaskLevel = EntityInfoTool.workPriority(entity: entity, workType: useCurrentType)
        /// 新任务等级
        let newTaskLevel = EntityInfoTool.workPriority(entity: entity, workType: useNewType)
        
        /// 当前任务级别更高，不能强转任务
        if currentTaskLevel < newTaskLevel {
            return false
        }else if currentTaskLevel > newTaskLevel {
            /// 当前任务级别低，能强转任务
            return true
        }else {
            /// 相等的情况
            /// 玩家设置的优先级相等，比较从左至右优先级，返回优先级高的
            let type = EntityActionTool.compareTaskPriority(type1: useNewType, type2: useCurrentType)

            /// 如果返回的是新任务，那么新任务优先级高，可以强转
            if type == task.type {
                return true
            }else{
                return false
            }
        }
      
    }

    
    /// 删除时，是否会撒下子类数据
    func removeAbleToLastSubEntity() {
        
    }
  
 
}



//MARK: - 🚩 优先级工具类 🚩 -
struct PriorityTool {
    
    /// 建造优先级
    static func buildPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self){
            return workComponent.building
        }
        return 0
    }
    
    /// 割除优先级
    static func cuttingPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self){
            return workComponent.cutting
        }
        return 0
    }
    
    /// 搬运优先级
    static func haulingPriority(_ entity: RMEntity) -> Int {
        if let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) {
            return workComponent.hauling
        }
        return 0
    }

    /// 存储优先级
    static func storagePriority(_ entity: RMEntity) -> Int {
        if let storageComponent = entity.getComponent(ofType: StorageInfoComponent.self) {
            return storageComponent.priority
        }
        return 0
    }

}



//MARK: - 🚩 EntityInfo 工具类 🚩 -
struct EntityInfoTool {
    
    /// 当前正在执行的任务
    static func currentTask(_ entity: RMEntity) -> WorkTask? {
        if let taskComponent = entity.getComponent(ofType: TaskQueueComponent.self) {
            if taskComponent.tasks.count > 0 {
                return taskComponent.tasks.first!
            }
        }
        
        return nil
    }
    
    /// 当前实体原料
    static func materialType(_ entity: RMEntity) -> MaterialType {
        
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return MaterialType.unowned
        }
        
        return MaterialType(rawValue: haulComponent.materialType) ?? MaterialType.unowned
    }
    
    /// 当前可以承担的重量
    static func remainingCarryCapacity(_ entity: RMEntity) -> Double {
        guard let carryComponent = entity.getComponent(ofType: CarryingCapacityComponent.self) else {
            return 0
        }
        return carryComponent.maxCapacity - carryComponent.currentLoad
    }
  
    /// 当前可搬运物的重量
    static func haulingWeight(_ entity:RMEntity) -> Double {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return 0
        }
      
        return Double(Int(haulComponent.weight * 100)) / 100.0  // 0.6
    }
    
    /// 当前可搬运物的数量
    static func haulingCount(_ entity: RMEntity) -> Int {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else {
            return 0
        }
        return haulComponent.currentCount
    }
    
    /// 是否在仓库
    static func isInStorage(entity: RMEntity, ecsManager: ECSManager) -> Bool{
        guard let ownedComponent = entity.getComponent(ofType: OwnedComponent.self) else {
            return false
        }
        
        var isInStorage = false
        
        let storage = ecsManager.getEntity(ownedComponent.ownedEntityID)
        if (storage != nil) && storage?.type == kStorageArea {
            isInStorage = true
        }
        
        return isInStorage
    }
    
    /// 仓库最大载容量
    static func maxStorageCapacity(storage: RMEntity) -> Int{
        guard let storageComponent = storage.getComponent(ofType: StorageInfoComponent.self) else {
            return 0
        }
        
        let size = storageComponent.size
        let cols = Int(size.width / tileSize)
        let rows = Int(size.height / tileSize)
        /// 存储区域总格子数
        let totalTiles = abs(cols * rows)
        /// 当前格子上存储的实体
        let storageEntities = storageComponent.saveEntities
        
        let lastStorageArea = totalTiles - storageEntities.count
        
        return lastStorageArea * 75
    }
    
    
    /// 蓝图需要的数量
    static func blueprintNeedCount(_ entity: RMEntity,
                                   _ material: Int) -> Int {
        
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return 0
        }
        /// 需要的原材料
        for (materialType,valueCount) in blueComponent.alreadyMaterials {
            /// 说明这个蓝图缺此材料
            if Int(materialType) == material {
                let maxCount = blueComponent.materials[materialType] ?? 0
                return maxCount - valueCount
            }
        }
        
        return 0
    }
    
    /// 蓝图所需素材是否完毕
    static func blueprintIsComplete(_ entity: RMEntity) {
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        let maxMaterials = blueComponent.materials
        let alreadyMaterials = blueComponent.alreadyMaterials
        
        var isComplete = true
        for (key,count) in alreadyMaterials {
            let maxCount = maxMaterials[key]!
            if maxCount != count {
                isComplete = false
            }
        }
        blueComponent.isMaterialCompelte = isComplete
    }
    
    /// 获取所有可做的任务
    static func allCanDoTask(_ entity: RMEntity) -> [WorkType] {
        guard let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) else {
            return []
        }

        // 映射所有任务及其优先级
        let priorityMap: [(WorkType, Int)] = [
            (.Firefighting, workComponent.firefighting),
            (.SelfCare, workComponent.selfCare),
            (.Doctor, workComponent.doctor),
            (.Rest, workComponent.rest),
            (.Basic, workComponent.basic),
            (.Supervise, workComponent.supervise),
            (.AnimalHandling, workComponent.animalHandling),
            (.Cooking, workComponent.cooking),
            (.Hunting, workComponent.hunting),
            (.Building, workComponent.building),
            (.Growing, workComponent.growing),
            (.Mining, workComponent.mining),
            (.Cutting, workComponent.cutting),
            (.Smithing, workComponent.smithing),
            (.Tailoring, workComponent.tailoring),
            (.Art, workComponent.art),
            (.Crafting, workComponent.crafting),
            (.Hauling, workComponent.hauling),
            (.Cleaning, workComponent.cleaning),
            (.Research, workComponent.research)
        ]

        // 过滤掉不能做的（优先级 <= 0），然后按优先级升序排列
        return priorityMap
            .filter { $0.1 > 0 }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
    }
    
    /// 获取此状态的优先级
    static func workPriority(entity: RMEntity?,
                             workType: WorkType) -> Int{
        
        guard let entity = entity else {
            return 3
        }
        
        guard let workComponent = entity.getComponent(ofType: WorkPriorityComponent.self) else {
            return 0
        }
        
        switch workType {
        case .Firefighting:
            return workComponent.firefighting
        case .SelfCare:
            return workComponent.selfCare
        case .Doctor:
            return workComponent.doctor
        case .Rest:
            return workComponent.rest
        case .Basic:
            return workComponent.basic
        case .Supervise:
            return workComponent.supervise
        case .AnimalHandling:
            return workComponent.animalHandling
        case .Cooking:
            return workComponent.cooking
        case .Hunting:
            return workComponent.hunting
        case .Building:
            return workComponent.building
        case .Growing:
            return workComponent.growing
        case .Mining:
            return workComponent.mining
        case .Cutting:
            return workComponent.cutting
        case .Smithing:
            return workComponent.smithing
        case .Tailoring:
            return workComponent.tailoring
        case .Art:
            return workComponent.art
        case .Crafting:
            return workComponent.crafting
        case .Hauling:
            return workComponent.hauling
        case .Cleaning:
            return workComponent.cleaning
        case .Research:
            return workComponent.research
        }
    }
    
    /// 可收货量
    static func currentHarvestAmount(entity: RMEntity) -> Int {
        guard let plantComponent = entity.getComponent(ofType: PlantBasicInfoComponent.self) else {
            return 0
        }
        let yield = Float(plantComponent.harvestYield) * plantComponent.growthPercent
        return max(1, Int(yield.rounded(.down)))
    }
    
    
    /// 获取种植区域的所有keys
    static func getGrowingAllKeys (targetEntity: RMEntity) -> [Int] {
        guard let areaComponent = targetEntity.getComponent(ofType: GrowInfoComponent.self) else {
            ECSLogger.log("此种植区域没有基础存储控件！💀💀💀")
            return []
        }
        
        let size = areaComponent.size
        
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
}



//MARK: - 🚩 EntityAction 工具类 🚩 -
struct EntityActionTool {
    
    /// 设置搬运走的数量
    static func setHaulingCount(entity: RMEntity,
                                count: Int) {
        guard let haulComponent = entity.getComponent(ofType: HaulableComponent.self) else { return }
        haulComponent.currentCount = count
        
        EntityNodeTool.updateHaulCountLabel(entity: entity, count: count)
    }
    
    /// 在实际搬运的时候，要考虑搬运人负重，所以需要更新蓝图对应的搬运中的素材数量
    static func setBlueprintHaulTaskCount(entity: RMEntity,
                                          blueEntity:RMEntity,
                                          count: Int){
        guard let blueComponent = blueEntity.getComponent(ofType: BlueprintComponent.self) else { return }
        
        let materialType = EntityInfoTool.materialType(entity)
        blueComponent.alreadyCreateHaulTask[materialType]?[entity.entityID] = count
    }
    
    /// 对应的存储仓库
    static func storageEntity(entity: RMEntity,
                              ecsManager: ECSManager) -> RMEntity?{
        guard let ownedComponent = entity.getComponent(ofType: OwnedComponent.self) else {
            return nil
        }
        
        return ecsManager.getEntity(ownedComponent.ownedEntityID)
        
    }
    
    /// 执行任务
    static func doTask(entity: RMEntity) {
        guard let taskComponent = entity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("执行任务失败，\(entity.name)没有任务列表。💀💀💀")
            return
        }

        guard let task = taskComponent.tasks.first else {
            ECSLogger.log("开始执行任务失败，任务列表为空。💀💀💀")
            return
        }

        guard let stateComponent = entity.getComponent(ofType: ActionStateComponent.self) else {
            ECSLogger.log("当前执行任务的角色：\(entity.name)没有状态组件。💀💀💀")
            return
        }
        
        
        /// 更改角色状态
        stateComponent.actions.append(EntityActionTool.taskDescription(task))
        /// 同步到视图
        RMInfoViewEventBus.shared.publish(.updateCharacter)
        
        RMEventBus.shared.publish(.doTask(entityID: entity.entityID, task: task))
    }
    
    /// 完成任务
    static func completeTaskAction(entity: RMEntity,
                                   task: WorkTask) {
        
        task.isCompleted = true
        
        guard let workComponent = entity.getComponent(ofType: TaskQueueComponent.self) else {
            ECSLogger.log("此实体没有任务组件")
            return
        }
        
        if let index = workComponent.tasks.firstIndex(where: { $0.id == task.id }) {
            workComponent.tasks.remove(at: index)
        }else {
            ECSLogger.log("在实体队列中的任务删除失败，没找到Index💀💀💀")
        }
        
        writeLog(entity: entity, text: "完成了任务：\(task.type)")
        
        workComponent.completeTask(task: task)
    }
    
    /// 添加任务
    static func addTask(entity: RMEntity,
                 task: WorkTask) {
        guard let taskCompnent = entity.getComponent(ofType: TaskQueueComponent.self) else { return }
        taskCompnent.tasks.insert(task, at: 0)
    }
    
    /// 移除任务
    static func removeTask(entity: RMEntity,
                           task: WorkTask) {
        guard let taskCompnent = entity.getComponent(ofType: TaskQueueComponent.self) else { return }
        if let index = taskCompnent.tasks.firstIndex(where: {
            $0.id == task.id
        }){
            taskCompnent.tasks.remove(at: index)
        }
        
        if taskCompnent.tasks.count > 1 {
            ECSLogger.log("为什么会大于一个任务？？？？💀💀💀")
        }
    }
    
    /// 设置开始休息状态
    static func startRest(entity: RMEntity){
        
        guard let energyComponent = entity.getComponent(ofType: EnergyComponent.self) else {
            ECSLogger.log("开始休息动画失败，未找到执行人能量组件👻👻👻")
            return
        }
        
        ECSLogger.log("设置实体进入休息队列中！😏")

        energyComponent.isResting = true
        /// 实体休息状态改变
        RMEventBus.shared.publish(.restStatusChange(entity: entity, isRest: true))
        energyComponent.alreadySend = false
        
    }
    
    /// 返回任务的描述文本
    static func taskDescription(_ task: WorkTask) -> String {
        switch task.type {
        case .Firefighting:
            return textAction("正在灭火")
        case .SelfCare:
            return textAction("正在自我治疗")
        case .Doctor:
            return textAction("正在治疗其他人")
        case .Rest:
            return textAction("正在休息")
        case .Basic:
            return textAction("正在执行基础任务")
        case .Supervise:
            return textAction("正在监管")
        case .AnimalHandling:
            return textAction("正在驯兽")
        case .Cooking:
            return textAction("正在烹饪")
        case .Hunting:
            return textAction("正在狩猎")
        case .Building:
            return textAction("正在建造")
        case .Growing:
            return textAction("正在种植")
        case .Mining:
            return textAction("正在采矿")
        case .Cutting:
            return textAction("正在砍树")
        case .Smithing:
            return textAction("正在锻造")
        case .Tailoring:
            return textAction("正在缝纫")
        case .Art:
            return textAction("正在进行艺术创作")
        case .Crafting:
            return textAction("正在制作物品")
        case .Hauling:
            return textAction("正在搬运")
        case .Cleaning:
            return textAction("正在清洁")
        case .Research:
            return textAction("正在研究")
        }
    }
    
    /// 实体写日志
    static func writeLog(entity: RMEntity,
                         text:String){
        let eventLog = DBManager.shared.getEventLog()
        eventLog.addLog(from: entity.entityID, to: entity.entityID, content: text, emotion: .neutral)
        DBManager.shared.updateEventLog(eventLog)
    }
    
    
    
   

    
    /// 比较任务优先级
    /// 相等优先级情况下，对比type
    static func compareTaskPriority(type1:WorkType,
                                    type2:WorkType) -> WorkType{
        // 根据定义顺序决定优先级，越靠前越高
        let priorityList: [WorkType] = WorkType.allCases

        // 获取两个 type 在列表中的索引
        guard let index1 = priorityList.firstIndex(of: type1),
              let index2 = priorityList.firstIndex(of: type2) else {
            // 如果找不到，默认返回 type1
            return type1
        }

        // 谁的 index 更小，说明优先级更高
        return index1 <= index2 ? type1 : type2
    }
}

//MARK: - 💀 实体Node相关的操作 💀 -
struct EntityNodeTool {
    
    /// 更新数量Node
    static func updateHaulCountLabel(entity: RMEntity,
                                     count: Int) {
        guard let labelNode = entity.node?.childNode(withName: "haulCount") as? SKLabelNode else { return }
        labelNode.text = "\(count)"
    }
    /// 砍伐完成
    static func cuttingFinish(targetNode: RMBaseNode) {
        targetNode.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.3),SKAction.removeFromParent()]))
    }
    
    /// 停止砍树
    static func stopCuttingAnimation(entity: RMEntity) {
        guard let targetNode = entity.node else {
            ECSLogger.log("强制停止砍伐失败，没有找到对应的Node：\(entity.name)💀💀💀")
            return
        }
        
        let cutting = targetNode.childNode(withName: "cutting")
        cutting?.removeFromParent()
        targetNode.progressBar.isHidden = true
    }
    
    /// 停止建造
    static func stopBuildingAnimation(entity: RMEntity) {
        guard let targetNode = entity.node else {
            ECSLogger.log("强制停止建造失败，没有找到对应的Node：\(entity.name)💀💀💀")
            return
        }
        
        let building = targetNode.childNode(withName: "building")
        building?.removeFromParent()
        targetNode.progressBar.isHidden = true
    }
    
    /// 休息
    static func restAnimation(entity: RMEntity,
                              tick: Int) {
        guard let executorNode = entity.node else { return }
        
        if executorNode.zLabel.parent == nil { executorNode.addChild(executorNode.zLabel) }
        executorNode.zLabel.isHidden = false
        
        let alpha = executorNode.zLabel.alpha - 0.01 * Double(tick)
        let x = executorNode.zLabel.position.x + CGFloat.random(in: 0.1...0.7) * Double(tick)
        let y = executorNode.zLabel.position.y + CGFloat.random(in: 0.1...0.7) * Double(tick)
        executorNode.zLabel.alpha = alpha
        executorNode.zLabel.position = CGPoint(x: x, y: y)
        
        if executorNode.zLabel.alpha <= 0 {
            executorNode.zLabel.alpha = 1
            executorNode.zLabel.position = CGPoint(x: 0, y: 0)
        }
    }
    
    /// 停止休息
    static func endRestAnimation(entity: RMEntity){
        guard let executorNode = entity.node else { return }
        executorNode.zLabel.isHidden = true
    }
}
