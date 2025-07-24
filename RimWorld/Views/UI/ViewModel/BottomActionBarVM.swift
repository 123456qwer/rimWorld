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
        
        /// 规划子类，区域选择
        view.planBtnSaveArea.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            self.areaTap()
        }).store(in: &cancellables)
        
        /// 规划子类，建造
        view.planBtnBuild.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            self.buildTap()
        }).store(in: &cancellables)
        
        /// 规划子类，移除
        view.plantBtnRemove.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            self.removeTap()
        }).store(in: &cancellables)
    }
    
}


// Action
extension BottomActionBarVM{
    
    /// 工作
    func tapWork(){
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
        
        if workPanelVM != nil {
            workPanelVM?.bindView?.removeFromSuperview()
        }
        
        let workView = WorkPanelView()
        workView.backgroundColor = .brown
        UIApplication.ml_keyWindow?.addSubview(workView)
       
        
        workView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(5.0/6.0)
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
        
        workPanelVM = WorkPanelVM()
        workPanelVM?.bindView(workView, gameContext: gameContext)
    }
    
    /// 点击规划
    func tapPlan() {
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
        
        guard let view = bindView else { return }
        view.clickPlan()
        if view.planBtn.isSelected == false {
            gameContext.currentMode = .normal
        }
    }
    
    /// 点击了区域选择
    func areaTap() {
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
        
        guard let view = bindView else { return }
        gameContext.currentMode = .selectingArea
        view.planBtn.setTitle(textAction("Storage"), for: .normal)
        view.planBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        view.hiddenSubButton()
    }
    
    /// 点击了建造
    func buildTap() {
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    
        guard let view = bindView else { return }
        gameContext.currentMode = .build
        view.planBtn.setTitle(textAction("Build"), for: .normal)
        view.planBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        view.hiddenSubButton()
    }
    
    /// 点击了拆除
    func removeTap() {
        
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
        
        guard let view = bindView else { return }
        gameContext.currentMode = .deconstruct
        view.planBtn.setTitle(textAction("Deconstruct"), for: .normal)
        view.planBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        view.hiddenSubButton()
    }
}
