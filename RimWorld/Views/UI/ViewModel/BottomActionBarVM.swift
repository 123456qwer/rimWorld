//
//  BottomActionBarVM.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import Combine
import UIKit

class BottomActionBarVM: NSObject {

    var cancellables = Set<AnyCancellable>()
    weak var bindView:BottomActionBar?
    weak var gameContext:RMGameContext!
    var workPanelVM:WorkPanelVM?
    
    func bindAction(_ view:BottomActionBar,
                    gameContext:RMGameContext) {
        
        self.bindView = view
        self.gameContext = gameContext
        
        /// 点击工作
        view.workBtn.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            self.tapWork()
        }).store(in: &cancellables)
        
        /// 点击规划
        view.planBtn.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            self.tapPlan()
        }).store(in: &cancellables)
 
    }
    
}


// Action
extension BottomActionBarVM{
    
    /// 工作
    func tapWork(){
        RMEventBus.shared.requestClickEmpty()
        RMEventBus.shared.requestClickBottomButton(buttonType: .work)
    }
    
    /// 点击规划
    func tapPlan() {
        
        /// 再次点击，取消之前的操作
        if bindView?.isSelect == true {
            gameContext.currentMode = .normal
            bindView?.updateBottomBtn(actionType: .none)
        }else{
            RMEventBus.shared.requestClickEmpty()
            RMEventBus.shared.requestClickBottomButton(buttonType: .architect)
        }
 
    }
 
   
}
