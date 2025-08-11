//
//  UISystem+WorkInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation
import UIKit

extension UISystem {
    
    func showWorkInfoView() {
        
        removeAllInfoAction()

        workInfoView = WorkPanelView()
        workInfoView!.backgroundColor = .brown
        UIApplication.ml_keyWindow?.addSubview(workInfoView!)
       
        workInfoView!.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(5.0/6.0)
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
        
        workPanelVM = WorkPanelVM()
        workPanelVM?.bindView(workInfoView!, gameContext: gameContext)
        
    }
    
    func removeWorkInfo() {
        workPanelVM = nil
        workInfoView?.removeFromSuperview()
        workInfoView = nil
    }
}
