//
//  UISystem+MiningInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import UIKit

/// 矿产信息
extension UISystem {
    
    /// 矿产信息
    func showMiningInfo(node: RMBaseNode, nodes: [Any]) {
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeAllInfoAction()
        
        miningInfoView       = MiningInfoView()
        miningInfoView?.ecsManager = ecsManager
        
        UIApplication.ml_keyWindow?.addSubview(miningInfoView!)
        
        miningInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(1.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        miningInfoView?.setData(entity)
        
        
        miningInfoView?.nextBlock = {[weak self] in
            guard let self = self else {return}
            self.nextAction(node: node, nodes: nodes)
        }

    }
    
    func removeMiningInfo(){
        miningInfoView?.removeFromSuperview()
        miningInfoView = nil
    }
}
