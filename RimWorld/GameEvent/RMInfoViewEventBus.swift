//
//  RMInfoViewEventBus.swift
//  RimWorld
//
//  Created by wu on 2025/7/8.
//

import Foundation
import Combine

/// 事件中心
enum InfoViewEvent {
    
    /// 植物实时刷新
    case updatePlant
    
    /// 人物当前状态刷新
    case updateCharacter
    
    /// 刷新蓝图
    case updateBlueprint
}

/// 事件总线（针对显示的view）
final class RMInfoViewEventBus {
    
    static let shared = RMInfoViewEventBus()
    
    private let subject = PassthroughSubject<InfoViewEvent, Never>()
    
    private init () {}
    
    func publish(_ event: InfoViewEvent) {
        subject.send(event)
    }
    
    func publisher() -> AnyPublisher<InfoViewEvent, Never> {
        subject.eraseToAnyPublisher()
    }
    
}


extension RMInfoViewEventBus {
    /// 刷新蓝图界面
    func requestReloadBlueprintInfo(){
        RMInfoViewEventBus.shared.publish(.updateBlueprint)
    }
    /// 刷新树界面
    func requestTreeInfo(){
        RMInfoViewEventBus.shared.publish(.updatePlant)
    }
}
