//
//  UISystem+MainInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import UIKit

extension UISystem {
    
    /// 规划，主操作界面
    func showMainControllInfoView(){
        
        removeAllInfoAction()
        
        mainConrollInfoView       = MainControllInfoView()
        mainConrollInfoView?.ecsManager = ecsManager
        
        UIApplication.ml_keyWindow?.addSubview(mainConrollInfoView!)
        
        let subInfoView = MainSubInfoView()
        mainConrollInfoView?.subInfoView = subInfoView
        subInfoView.gameContext = gameContext
        UIApplication.ml_keyWindow?.addSubview(subInfoView)

        
        mainConrollInfoView!.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.leading.equalToSuperview().offset(kSafeLeft)
            make.height.equalToSuperview().multipliedBy(1.0/2.0)
            make.width.equalToSuperview().multipliedBy(1/5.0)
        }
        
        subInfoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeBottom - kBottomActionBarHeight)
            make.left.equalTo(mainConrollInfoView!.snp.right).offset(5.0)
            make.height.equalTo(44.0)
            make.width.equalToSuperview().multipliedBy(3/5.0)
        }
        
    }
    
    func removeMainInfo() {
        mainConrollInfoView?.removeFromSuperview()
        mainConrollInfoView?.subInfoView?.removeFromSuperview()
        mainConrollInfoView = nil
    }
    
}
