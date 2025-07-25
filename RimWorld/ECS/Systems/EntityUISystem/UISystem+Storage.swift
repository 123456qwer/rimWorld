//
//  UISystem+SaveArea.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import Foundation
import UIKit
extension UISystem {
    
    /// 展示存储区域
    func showStorageInfo(node: RMBaseNode, nodes: [Any]){
        guard let entity = node.rmEntity else {
            ECSLogger.log("此node：\(node.name ?? "")，未有实体")
            return
        }
        
        removeAllInfoAction()
        
        storageInfoView       = StorageInfoView()
        
        UIApplication.ml_keyWindow?.addSubview(storageInfoView!)
        
        storageInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(3.0/4.0)
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        
        storageInfoView?.setData(entity)
    }
    
    
    func removeStorageInfo() {
        storageInfoView?.removeFromSuperview()
        storageInfoView = nil
    }
}
