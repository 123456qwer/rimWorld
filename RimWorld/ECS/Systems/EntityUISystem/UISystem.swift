//
//  UISystem.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import SpriteKit
import Combine

class UISystem: System {
    
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - 角色 -
    /// 角色顶部可选按键高度
    let tabbarHeight = 25
    /// 当前选中log
    var tab:Tab = Tab.none
    /// 角色基本信息
    var characterView:CharacterInfoView = CharacterInfoView()
    /// 角色顶部可选按键
    var characterTabbarView:CharacterTabbarView = CharacterTabbarView()
    /// 负重、温度、装备（装备）
    var characterEquipView:CharacterEquipView?
    /// 角色社交关系图（社交）
    var characterSocilaView:CharacterSocialView?
    /// 角色详情（角色）
    var characterDetailView:CharacterDetailInfoView?
    /// 角色心情详情（需求）
    var characterMoodView:CharacterMoodStatusView?
    /// 角色身体部位、手术列表（健康）
    var characterBodyView:CharacterBodyPartView?
    /// 日志（包括社交和战斗）
    var characterLogView:CharacterLogView?
    
    // MARK: - 环境 -
    var treeInfoView:PlantInfoView?
    /// 通用物品
    var goodsInfoView:CommonGoodsInfoView?
    /// 矿产
    var miningInfoView:MiningInfoView?
    
    // MARK: - 存储区域设置 -
    var storageInfoView:StorageInfoView?
    
    // MARK: - 种植区域设置 -
    var growingInfoView: GrowingInfoView?
    
    // MARK: - 蓝图 -
    var blueprintInfoView:BlueprintInfoView?
    
    // MARK: - 规划 -
    var mainConrollInfoView: MainControllInfoView?
    
    // MARK: - 工作盘 -
    var workInfoView: WorkPanelView?
    var workPanelVM: WorkPanelVM?
    
    
    let ecsManager: ECSManager
    let gameContext: RMGameContext
    
    init (ecsManager: ECSManager, gameContext: RMGameContext) {
        self.ecsManager = ecsManager
        self.gameContext = gameContext
    }
    
    
    /// 点击实体
    func clickEntity(_ entity:RMEntity,_ nodes:[Any]) {
        
        guard let node = entity.node else {
            ECSLogger.log("此实体没有对应的Node：\(entity.name)")
            return
        }
        
        let tempXScale = node.defaultXscale
        let tempYScale = node.defaultYscale

        let xScale = node.xScale * 1.3
        let yScale = node.yScale * 1.3
        
        let gr1 = SKAction.group([SKAction.scaleX(to: xScale, duration: 0.15),SKAction.scaleY(to: yScale, duration: 0.15)])
        let gr2 = SKAction.group([SKAction.scaleX(to: tempXScale, duration: 0.15),SKAction.scaleY(to: tempYScale, duration: 0.15)])

        
        node.run(SKAction.sequence([gr1,gr2]))
        
        if entity.type == kCharacter {
            /// 点击角色
            showCharacterInfo(node: node, nodes: nodes)
        }else if entity.type == kTree ||
                    entity.type == kRice ||
                    entity.type == kAppleTree{
            /// 点击植物
            showPlantInfo(node: node, nodes: nodes)
        }else if entity.type == kWood || entity.type == kOre{
            /// 点击物品（木头、矿产）
            showGoodsInfo(node: node, nodes: nodes)
        }else if entity.type == kStorageArea {
            /// 点击了存储区域
            showStorageInfo(node: node, nodes: nodes)
        }else if entity.type == kGrowingArea {
            /// 点击种植区域
            showGrowingInfo(node: node, nodes: nodes)
        }else if entity.type == kBlueprint {
            /// 点击蓝图
            showBlueprintInfo(node: node, nodes: nodes)
        }else if entity.type == kStone {
            /// 点击矿产
            showMiningInfo(node: node, nodes: nodes)
        }
    }
    
    
    /// 点击按钮
    func clickButton(buttonType: ButtonType) {
        
        switch buttonType {
        case .architect:
            showMainControllInfoView()
        case .work:
            showWorkInfoView()
        default:
            break
        }
        
    }
    
    
    /// 点击下一个
    func nextAction(node: RMBaseNode,
                    nodes: [Any]){
        
        // 找到下一个不同名字的 RMBaseNode
        guard let currentName = node.name,
              let nextNode = nodes.compactMap({ $0 as? RMBaseNode }).first(where: { $0.name != currentName && EntityAbilityTool.ableToClick($0.rmEntity!) }) else {
            self.removeAllInfoAction()
            return
        }

        // 构造新的 nodes 列表，移除当前 node
        let filteredNodes = nodes.filter {
            guard let rmNode = $0 as? RMBaseNode else { return true }
            return rmNode.name != currentName
        }

        // 发布事件
        RMEventBus.shared.publish(.didSelectEntity(entity: nextNode.rmEntity ?? RMEntity(), nodes: filteredNodes))
    }
    
    
    func removeAllInfoAction() {
        removeMainInfo()
        removeWorkInfo()
        removeTreeInfo()
        removeMiningInfo()
        removeWoodInfo()
        removeUserInfo()
        removeStorageInfo()
        removeBlueprintInfo()
        removeGrowingInfo()
    }
}



