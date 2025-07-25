//
//  UISystem+Character.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import SpriteKit

/// 人物展示信息
extension UISystem {
    
    /// 隐藏角色详情
    func removeUserInfo(){
        characterView.removeFromSuperview()
        characterTabbarView.removeFromSuperview()
    
        removeAllCharacterTabbarViews()
        self.tab = .none
    }
    
    /// 移除之前所有展示的角色详情界面
    func removeAllCharacterTabbarViews(){
        characterDetailView?.removeFromSuperview()
        characterMoodView?.removeFromSuperview()
        characterSocilaView?.removeFromSuperview()
        characterBodyView?.removeFromSuperview()
        characterEquipView?.removeFromSuperview()
        characterLogView?.removeFromSuperview()
        
        characterMoodView = nil
    }
    
    /// 展示角色基本信息
    func showCharacterInfo (node: RMBaseNode, nodes: [Any]){
        
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeTreeInfo()
        removeWoodInfo()
        removeStorageInfo()
        removeBlueprintInfo()
        
        
        characterView.removeFromSuperview()
        characterTabbarView.removeFromSuperview()
        
        characterView       = CharacterInfoView()
        characterTabbarView = CharacterTabbarView()
        
        UIApplication.ml_keyWindow?.addSubview(characterView)
        UIApplication.ml_keyWindow?.addSubview(characterTabbarView)
        
        characterView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(1.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        characterTabbarView.snp.makeConstraints { make in
            make.bottom.equalTo(characterView.snp.top).offset(-2)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalTo(tabbarHeight)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        characterView.setupLayout(entity: entity)
        
        /// 选择标签切换人物详情
        characterTabbarView.onTabSelected = {[weak self, weak entity] tab in
            guard let self = self else { return }
            guard let entity = entity else { return }
            showInfoWithTab(tab,entity)
            self.tab = tab
        }
        
        /// 选择其他人物，详情也重新生成
        self.showInfoWithTab(self.tab,entity)
        
        
        /// 下一个
        characterView.nextBlock = {[weak self] in
            guard let self = self else {return}
            // 找到下一个不同名字的 RMBaseNode
            guard let currentName = node.name,
                  let nextNode = nodes.compactMap({ $0 as? RMBaseNode }).first(where: { $0.name != currentName }) else {
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
        
    }
    /// 根据tab展示详情
    func showInfoWithTab(_ tab: Tab,_ entity: RMEntity) {
        
        if tab == .none{
            removeAllCharacterTabbarViews()
        }else if tab == .character {
            self.showCharacterDetailInfo(entity: entity)
        }else if tab == .needs {
            self.showCharacterMoodInfo(entity: entity)
        }else if tab == .social {
            self.showCharacterSocialInfo(entity: entity)
        }else if tab == .health {
            self.showCharacterBodyInfo(entity: entity)
        }else if tab == .equipment {
            showCharacterEquipInfo(entity: entity)
        }else if tab == .log {
            showCharacterLogInfo(entity: entity)
        }
    }
    
    
    
    /// 战斗、对话记录（日志）
    func showCharacterLogInfo (entity: RMEntity) {
        removeAllCharacterTabbarViews()
        
        let logView = CharacterLogView()
        characterLogView = logView
        
        UIApplication.ml_keyWindow?.addSubview(logView)

        let widthPercent = 1.5/3.0
        logView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        logView.updateLayout(entity)
//        equipView.updateSocialLayout(entity)
    }
    /// 温度、负重、武器护甲（装备）
    func showCharacterEquipInfo (entity: RMEntity) {
        removeAllCharacterTabbarViews()
        
        let equipView = CharacterEquipView()
        characterEquipView = equipView
        
        UIApplication.ml_keyWindow?.addSubview(equipView)

        let widthPercent = 1.5/3.0
        equipView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        equipView.updateLayout(entity)
//        equipView.updateSocialLayout(entity)
    }
    /// 展示角色社交关系图（社交）
    func showCharacterSocialInfo (entity: RMEntity) {
        removeAllCharacterTabbarViews()
        
        let socialView = CharacterSocialView()
        characterSocilaView = socialView
        
        UIApplication.ml_keyWindow?.addSubview(socialView)

        let widthPercent = 1.5/3.0
        socialView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        socialView.updateSocialLayout(entity)
//        socialView.setupLeftLayout(entity)
//        socialView.setupRightLayout(entity)
    }
    /// 展示角色详情（角色）
    func showCharacterDetailInfo (entity: RMEntity) {
        
        removeAllCharacterTabbarViews()
        
        let detailView = CharacterDetailInfoView()
        characterDetailView = detailView
        
        UIApplication.ml_keyWindow?.addSubview(detailView)

        let widthPercent = 1.5/3.0
        detailView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        detailView.setupLeftLayout(entity)
        detailView.setupRightLayout(entity)
    }
    /// 展示角色心情状态（需求）
    func showCharacterMoodInfo (entity: RMEntity) {
        
        removeAllCharacterTabbarViews()
        
        let moodView = CharacterMoodStatusView()
        characterMoodView = moodView
        
        UIApplication.ml_keyWindow?.addSubview(moodView)

        let widthPercent = 1.5/3.0
        moodView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        moodView.setupLeftLayout(entity)
        moodView.setupRightLayout(entity)
        
    }
    /// 展示角色身体状况图（健康）
    func showCharacterBodyInfo (entity: RMEntity) {
        removeAllCharacterTabbarViews()
        
        let bodyPartView = CharacterBodyPartView()
        characterBodyView = bodyPartView
        
        UIApplication.ml_keyWindow?.addSubview(bodyPartView)

        let widthPercent = 1.5/3.0
        bodyPartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.width.equalToSuperview().multipliedBy(widthPercent)
            make.bottom.equalTo(characterTabbarView.snp.top)
        }
        
        bodyPartView.updateLayout(entity)
//        socialView.updateSocialLayout(entity)
    }
    
}
