//
//  Notification+Extensions.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation

extension Notification.Name {
    
    static let RMGameTimeDayChange = Notification.Name("RMGameTimeDayChange")
    static let RMGameTimeHourChange = Notification.Name("RMGameTimeHourChange")
    static let RMGameTimeHungerTick = Notification.Name("RMGameTimeHungerTick")
    static let RMGameTimeJoyTick = Notification.Name("RMGameTimeJoyTick")
    
    /// 没帧更新能量条
    static let RMGameTimeUpdateEnergy = Notification.Name("RMGameTimeUpdateEnergy")

    
    

}
