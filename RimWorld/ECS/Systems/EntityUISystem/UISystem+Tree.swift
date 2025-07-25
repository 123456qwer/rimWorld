//
//  UISystem+Tree.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import UIKit

extension UISystem {
    
    /// 树信息
    func showTreeInfo(node: RMBaseNode, nodes: [Any]) {
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeAllInfoAction()
        
        treeInfoView       = TreeInfoView()
        
        UIApplication.ml_keyWindow?.addSubview(treeInfoView!)
        
        treeInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(1.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        treeInfoView?.setData(entity)
        
        
        treeInfoView?.nextBlock = {[weak self] in
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
    
    /// 木头信息
    func showWoodInfo(node: RMBaseNode,
                      nodes: [Any]) {
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeAllInfoAction()
        
        woodInfoView = WoodInfoView()
        
        UIApplication.ml_keyWindow?.addSubview(woodInfoView!)
        
        woodInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(1.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        woodInfoView?.setData(entity)
        
        
        woodInfoView?.nextBlock = {[weak self] in
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
    

    func removeTreeInfo() {
        treeInfoView?.removeFromSuperview()
        treeInfoView = nil
    }
    
    func removeWoodInfo() {
        woodInfoView?.removeFromSuperview()
        woodInfoView = nil
    }
    
}
