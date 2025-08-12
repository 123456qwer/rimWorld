//
//  BaseScene.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation
import SpriteKit

class BaseScene:SKScene, RenderContext {
  
    /// 掌控全局
    let ecsManager = ECSManager()
    /// 游戏上下文
    var gameContext = RMGameContext()
    /// 摄像机
    let cameraNode = SKCameraNode()
    /// 避免多指操作
    var activeTouch:UITouch?
    /// 更新时间
    var lastUpdateTime: TimeInterval = 0
    
    var totalTicks = 0
    var tickAccumulator: Double = 0
    
    /// 时间
    var rmTime:RMGameTime = DBManager.shared.getTime()
    
    var tileMap: SKTileMapNode?
    var walkableMap: [[Bool]] = []

    
    var canGo:Bool = false
    
 
    /// 入口
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        createMap()
        
        self.camera = cameraNode
        self.addChild(cameraNode)
        
        initEntities()
        
        gameContext.ecsManager = ecsManager
        
        DispatchQueue.after(5) {
            self.canGo = true
        }
        
        
    }
    
    /// 初始化实例
    func initEntities() {
  
        /// 添加实体分类系统
        ecsManager.addSystem(entityCategorizationSystem)
        /// 添加渲染系统
        ecsManager.addSystem(renderSystem)
        /// 添加UI系统
        ecsManager.addSystem(uiSystem)
        /// 添加寻路逻辑系统
        ecsManager.addSystem(pathFindingSystem)
        /// 添加移动系统
        ecsManager.addSystem(movementSystem)
        /// 添加动画、执行任务系统
        ecsManager.addSystem(actionAnimationSystem)
        /// 添加饥饿系统
        ecsManager.addSystem(hungerSystem)
        /// 添加能量系统
        ecsManager.addSystem(energySystem)
        /// 添加娱乐系统
        ecsManager.addSystem(joySystem)
        /// 添加生成实体系统
        ecsManager.addSystem(createSystem)
        /// 添加植物成长系统
        ecsManager.addSystem(plantGrowthSystem)
        /// 添加任务系统
        ecsManager.addSystem(taskSystem)
        /// 添加移除实体系统
        ecsManager.addSystem(entityResourceSystem)
        
        /// 初始化各种行为
        ecsManager.setupAllEntityBehaviors(provider: self)
        
    }
    
 
    /// 根据是否有父ID来确认是直接添加到场景还是添加到某一Node上
    func addNode(_ node: RMBaseNode, to parentID: Int) {
        
        /// 先大概设置Z的位置
        node.zPosition = 10000 - node.position.y
        
       
        
        /// 已添加
        if node.parent != nil { return }
        
        if parentID == -1 {
            addChild(node)
        }else{
            if let parentNode = ecsManager.getEntityNode(parentID) {
                node.zPosition = 100
                parentNode.addChild(node)
            }else{
                addChild(node)
            }
        }
         
    }
    
    /// 捏合手势
    func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        var newScale = self.cameraNode.xScale / gesture.scale
        
        if newScale > 3 {
            newScale = 3
        }
        if newScale < 0.5 {
            newScale = 0.5
        }
        
        cameraNode.setScale(newScale)
        gesture.scale = 1
        
        if gesture.state == .ended {
            activeTouch = nil
        }
    }
    
    /// 根据实体ID获取Node
    func getNode(for entityID: Int) -> RMBaseNode? {
        return ecsManager.getEntityNode(entityID)
    }
    
   
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.canGo == false { return }
        
        var deltaTime = currentTime - lastUpdateTime
        if lastUpdateTime == 0 {
            deltaTime = 0
        }
        
        lastUpdateTime = currentTime

        tickAccumulator += deltaTime * 60 * rmTime.timeScale

        // 每当累积超过 1 tick，取整加入 totalTicks
        let ticksToAdd = Int(tickAccumulator)
        if ticksToAdd > 0 {
            
            rmTime.totalTicks += ticksToAdd
            tickAccumulator -= Double(ticksToAdd)

            /// 总时间轴 tick  60 tick / s
            let totalTicks = rmTime.totalTicks
            
            /// 根据时间更新对应的系统
            ecsManager.updateSystems(tick: totalTicks)
        }
        
        /// 更新能量条
        NotificationCenter.default.post(name: .RMGameTimeUpdateEnergy, object: self)

    }
    
    
    // MARK: - 系统初始化（懒加载）
    
    /// 输入系统
    lazy var inputSystem:InputSystem = {
        InputSystem(ecsManager: ecsManager,
                    gameContext: gameContext,
                    areaProvider: self)
    }()
    
    /// 饥饿值系统
    lazy var hungerSystem: HungerSystem = {
        HungerSystem(ecsManager: ecsManager)
    }()

    /// 能量值系统
    lazy var energySystem: EnergySystem = {
        EnergySystem(ecsManager: ecsManager)
    }()

    /// 娱乐值系统
    lazy var joySystem: JoySystem = {
        JoySystem(ecsManager: ecsManager)
    }()

    /// 渲染系统
    lazy var renderSystem: RenderSystem = {
        let system = RenderSystem(ecsManager: ecsManager, renderContent: self)
        return system
    }()

    /// UI 系统
    lazy var uiSystem: UISystem = {
        UISystem(ecsManager: ecsManager,gameContext: gameContext)
    }()

    /// 人物任务系统
    lazy var taskSystem: TaskSystem = {
        TaskSystem(ecsManager: ecsManager,
                            provider: self)
    }()

    /// 寻路系统
    lazy var pathFindingSystem: PathfindingSystem = {
        PathfindingSystem(ecsManager: ecsManager,
                          provider: self)
    }()

    /// 角色移动系统
    lazy var movementSystem: MovementSystem = {
        MovementSystem(ecsManager: ecsManager)
    }()

    /// 行为动画系统
    lazy var actionAnimationSystem: DoTaskSystem = {
        DoTaskSystem(ecsManager: ecsManager,
                     provider: self)
    }()
    
    /// 创建系统
    lazy var createSystem: EntityNodeFactorySystem = {
        EntityNodeFactorySystem(ecsManager: ecsManager, provider: self)
    }()
    
    /// 实体分类系统
    lazy var entityCategorizationSystem: EntityCategorizatonSystem = {
        EntityCategorizatonSystem(ecsManger: ecsManager)
    }()
    
    /// 移除实体系统
    lazy var entityResourceSystem: ResourceHarvestSystem = {
        ResourceHarvestSystem(ecsManager: ecsManager)
    }()
    
    /// 植物成长系统
    lazy var plantGrowthSystem: PlantGrowthSystem = {
        PlantGrowthSystem(ecsManager: ecsManager)
    }()

}





// MARK: - Pathfinding 方法注入 -
extension BaseScene: PathfindingProvider {
    
    /// 根据当前坐标，获取tile的实际坐标位置
    func converPointForTile(point: CGPoint) -> CGPoint {
        let changePoint = tileMap!.convert(point, from: self.scene!)

        // 获取列和行（注意坐标是反着的）
        let column = tileMap!.tileColumnIndex(fromPosition: changePoint)
        let row = tileMap!.tileRowIndex(fromPosition: changePoint)
        
        let returnPoint = tileMap!.centerOfTile(atColumn: column, row: row)
        
        return returnPoint
    }
    
    /// 是否可行走方法
    func isWalkable(x: Int, y: Int) -> Bool {
        let pos = CGPoint(x: x, y: y)
        // 将点击位置转换为 tileMap 的本地坐标系（如果 tileMap 不是在 (0,0)）
        let parent = tileMap!.parent
        let localPos = tileMap!.convert(pos, from: parent!)
        // 获取列和行（注意坐标是反着的）
        let column = tileMap!.tileColumnIndex(fromPosition: localPos)
        let row = tileMap!.tileRowIndex(fromPosition: localPos)
        
        // 越界检查
        guard row >= 0,
              column >= 0,
              row < walkableMap.count,
              column < walkableMap[row].count else {
            ECSLogger.log("数组越界了！💀💀💀")
            return false
        }
        
        return walkableMap[row][column]
    }
    
    /// 设置当前区域是否可行走
    func setWalkable(x: Int, y: Int, canWalk: Bool) {
        let pos = CGPoint(x: x, y: y)
        // 将点击位置转换为 tileMap 的本地坐标系（如果 tileMap 不是在 (0,0)）
        let parent = tileMap!.parent
        let localPos = tileMap!.convert(pos, from: parent!)
        // 获取列和行（注意坐标是反着的）
        let column = tileMap!.tileColumnIndex(fromPosition: localPos)
        let row = tileMap!.tileRowIndex(fromPosition: localPos)
        
        // 越界检查
        guard row >= 0,
              column >= 0,
              row < walkableMap.count,
              column < walkableMap[row].count else {
            ECSLogger.log("数组越界了！💀💀💀")
            return
        }
        
        walkableMap[row][column] = canWalk
    }
    
    
    /// 添加寻路的路径node
    func addPathNode(pathNode: SKSpriteNode) {
        self.addChild(pathNode)
    }
    
    
    func pointFromScene(_ entity: RMEntity) -> CGPoint {
        
        guard entity.getComponent(ofType: OwnedComponent.self) != nil else {
            return PositionTool.nowPosition(entity)
        }
        
        guard let father = entity.node?.parent else {
            return PositionTool.nowPosition(entity)
        }
        
        guard let target = entity.node else {
            return PositionTool.nowPosition(entity)
        }
        
        return father.convert(target.position, to: self)
        
    }
}



// MARK: - AreaSelect 方法注入 -
extension BaseScene: AreaSelectProvider {
    
    /// 选择区域
    func selectArea(start: CGPoint,
                    end: CGPoint,
                    size:CGSize,
                    areaNode:SKSpriteNode) {
        
        // 将起始点和结束点转换为 tile 的中心坐标（对齐到 tile）
        let tileStartPoint = converPointForTile(point: start)
        let tileEndPoint = converPointForTile(point: end)

        // 计算区域起点在 tile 上对齐的 x 坐标：
        // 如果 tile 的中心在 start 点的右边，就向左偏移半格（tileSize/2）；否则向右偏移半格
        let startX = tileStartPoint.x > start.x ? tileStartPoint.x - tileSize / 2 : tileStartPoint.x + tileSize / 2
        let startY = tileStartPoint.y > start.y ? tileStartPoint.y - tileSize / 2 : tileStartPoint.y + tileSize / 2
       
        let endX = tileEndPoint.x > end.x ? tileEndPoint.x - tileSize / 2 : tileEndPoint.x + tileSize / 2
        let endY = tileEndPoint.y > end.y ? tileEndPoint.y - tileSize / 2 : tileEndPoint.y + tileSize / 2
     
        // 得到 tile 对齐后的起点和终点
        let nodeStartPoint = CGPoint(x: startX, y: startY)
        let nodeEndPoint = CGPoint(x: endX, y: endY)

        // 计算横向和纵向选中了多少个 tile（tile 尺寸为 tileSize）
        let xCount = abs((nodeStartPoint.x - nodeEndPoint.x) / tileSize)
        let yCount = abs((nodeStartPoint.y - nodeEndPoint.y) / tileSize)
        
        // 决定最终选区框的起始位置：左上角 or 右上角
        // 如果从左向右拖，选 nodeStartPoint.x，否则选 nodeEndPoint.x
        let nodeX = start.x < end.x ? nodeStartPoint.x : nodeEndPoint.x
        let nodeY = start.y > end.y ? nodeStartPoint.y : nodeEndPoint.y

        let areaPoint = CGPoint(x: nodeX, y: nodeY)
        
        // 设置用于显示选择区域的节点（areaNode）的起点位置和尺寸
        areaNode.position = areaPoint
        areaNode.setScale(1)
        
        let areaSize = CGSize(width: xCount * tileSize, height: -yCount * tileSize)
        
        // 注意：高度为负，是为了支持 SpriteKit 中 Y 轴向上为正的坐标系统
        areaNode.size = areaSize
        
        areaNode.removeFromParent()
        
        /// 可以在这个区域里放入的格子
    
        if yCount <= 0 || xCount <= 0 { return }
        
        
        var type = ""
        var params:EntityCreationParams?
        var isCancel = false
        var isCuttring = false
        var isMining = false
        
        if gameContext.currentMode == .storage {
            /// 仓库
            params = StorageParams( size: areaSize )
            type = kStorageArea
        }else if gameContext.currentMode == .growing {
            /// 种植区域
            params = GrowingParams(size: areaSize, cropType: .rice)
            type = kGrowingArea
        }else if gameContext.currentMode == .cancel {
            isCancel = true
        }else if gameContext.currentMode == .cutting {
            isCuttring = true
        }else if gameContext.currentMode == .mining {
            isMining = true
        }
        
        
        /// 仓库，种植
        if gameContext.currentMode == .storage || gameContext.currentMode == .growing {
            RMEventBus.shared.requestCreateEntity(type: type,
                                                 point: areaPoint,
                                                params: params!)
        }
       

        
        
        for y in 0...Int(yCount - 1) {
            for x in 0...Int(xCount - 1) {
                let pointX = Int(nodeX + tileSize / 2.0) + x * Int(tileSize)
                let pointY = Int(nodeY - tileSize / 2.0) + y * Int(-tileSize)
                let point = CGPoint(x: pointX, y: pointY)
                
                let texture = TextureManager.shared.getTexture("格子")
                let node = SKSpriteNode(texture: texture)
                node.size = CGSize(width: tileSize, height: tileSize)
                node.zPosition = 100000
                node.position = converPointForTile(point: point)
                self.addChild(node)
                
                let action = SKAction.sequence([SKAction.scale(to: 2.0, duration: 0.15),SKAction.scale(to: 0, duration: 0.15),SKAction.removeFromParent()])
                node.run(action)
                
                if isCancel {
                    cancelAction(point)
                }else if isCuttring {
                    cuttingAction(point)
                }else if isMining {
                    miningAction(point)
                }
            }
        }
        
   
    }
    
    /// 取消操作
    private func cancelAction(_ point: CGPoint) {
        let nodes = self.nodes(at: point)
        for node in nodes {
            guard let node = node as? RMBaseNode else { continue }
            guard let entity = node.rmEntity else { continue }
            
            EntityActionTool.cancelAction(entity: entity)
        }
    }
    
    /// 割除操作
    private func cuttingAction(_ point: CGPoint) {
        let nodes = self.nodes(at: point)
        for node in nodes {
            guard let node = node as? RMBaseNode else { continue }
            guard let entity = node.rmEntity else { continue }
            
            EntityActionTool.cuttingAction(entity: entity,ecsManager: ecsManager)
        }
    }
    
    /// 采矿操作
    private func miningAction(_ point: CGPoint) {
        let nodes = self.nodes(at: point)
        for node in nodes {
            guard let node = node as? RMBaseNode else { continue }
            guard let entity = node.rmEntity else { continue }
            
            EntityActionTool.miningAction(entity: entity,ecsManager: ecsManager)
        }
    }
}



// MARK: - Common -
extension BaseScene {
    
    /// 创建地图
    func createMap() {
        
        let columns = 161
        let rows = 121
        let tileSize = CGSize(width: tileSize, height: tileSize)

        // 1. 加载4种贴图，并创建 tileDefinitions
        let textureNames = ["格子","axe"]
        var tileGroups: [SKTileGroup] = []

        for name in textureNames {
            let texture = SKTexture(imageNamed: name)
            let tileDef = SKTileDefinition(texture: texture, size: tileSize)
            let tileGroup = SKTileGroup(tileDefinition: tileDef)
            tileGroups.append(tileGroup)
        }

        // 2. 创建 tileSet
        let tileSet = SKTileSet(tileGroups: tileGroups)

        // 3. 创建 tileMap
        let tileMap = SKTileMapNode(tileSet: tileSet,
                                     columns: columns,
                                     rows: rows,
                                     tileSize: tileSize)
        tileMap.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tileMap.position = CGPoint.zero

        walkableMap = Array(repeating: Array(repeating: true, count: columns), count: rows)

        
        // 4. 随机设置每个 tile
        for row in 0..<rows {
            for column in 0..<columns {
              
                let randomTileGroup = tileGroups[0]
                tileMap.setTileGroup(randomTileGroup, forColumn: column, row: row)
                
                walkableMap[row][column] = true
            }
        }

        self.addChild(tileMap)
        
        self.tileMap = tileMap

    }
    
}
