//
//  WorkPanelVM.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit
import Combine

class WorkPanelVM: NSObject {
    
    
    weak var bindView:WorkPanelView?
    weak var gameContext:RMGameContext?

    var cancellables = Set<AnyCancellable>()

    /// 角色
    var characters:[RMEntity] = []
  
    
    func bindView(_ view:WorkPanelView,
                  gameContext:RMGameContext) {
       
        self.gameContext = gameContext
        self.bindView = view
        
        view.clickWorkLevelBlock = {[weak self] sender in
            guard let self = self else {return}
            self.clickWorkType(sender)
        }
        
        
        /// 点击关闭按钮
        view.close.publisher(for: .touchUpInside).sink(receiveValue: {[weak self] _ in
            guard let self = self else {return}
            RMEventBus.shared.requestClickEmpty()
        }).store(in: &cancellables)
        
        
        /// 获取所有角色实体
        for entity in gameContext.getAllEntities() {
            if entity.type == kCharacter {
                characters.append(entity)
            }
        }
        view.setupUI(characters)

    }
    
    
    /// 修改角色的工作优先级
    func clickWorkType(_ sender:UIButton) {
        
        var nowLevel = sender.titleLabel?.text ?? "0"
        if nowLevel == "" {
            nowLevel = "0"
        }
        var changeLevel = Int(nowLevel)! + 1
        if changeLevel > 4{
            changeLevel = 0
        }
        
        if changeLevel == 0 {
            sender.setTitle("", for: .normal)
            sender.titleLabel?.text = ""
        }else{
            sender.setTitle("\(changeLevel)", for: .normal)
        }
        
        /// 获取数组中的位置
        let tag = sender.tag
        let characterIndex = tag / 100 - 1
        let character = characters[characterIndex]
        
        /// 获取哪一行
        let column = tag % 100
        let workPriorityComponent = character.getComponent(ofType: WorkPriorityComponent.self)
        workPriorityComponent?.updateWorkPriority(for: column, value: changeLevel)
        bindView?.changeSenderTitleColor(sender)

        /// 修改优先级
        RMEventBus.shared.requestChangePriorityEntity(entity: character, workType: entityWorkType(index: column) ?? .Rest)
    }
    
    func entityWorkType(index: Int) -> WorkType? {
        var allCases = WorkType.allCases
        allCases.remove(at: 0)
        guard index >= 0 && index < allCases.count else { return nil }
        return allCases[index]
    }
}
