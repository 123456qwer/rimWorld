//
//  UISystem+Growing.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation
import UIKit
extension UISystem {
    
    /// 展示种植区域
    func showGrowingInfo(node: RMBaseNode, nodes: [Any]){
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeAllInfoAction()
        
        growingInfoView       = GrowingInfoView()
        
        UIApplication.ml_keyWindow?.addSubview(growingInfoView!)
        
        growingInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(3.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        growingInfoView?.setData(entity)
    }
    
    
    func removeGrowingInfo() {
        growingInfoView?.removeFromSuperview()
        growingInfoView = nil
    }
    
}
