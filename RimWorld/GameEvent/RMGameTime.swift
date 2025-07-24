//
//  RMGameTime.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import WCDBSwift

import Combine

final class RMGameTime: TableCodable,Component {
    
    var cancellables = Set<AnyCancellable>()

    
    func bindEntityID(_ bindEntityID: Int) {}
    
    
    var timeID:Int = 1
    var totalTime: Double = 0
    /// 时间倍率（1x，2x，暂停=0）
    var timeScale: Double = 1.0
    
    /// 秒 = 60 tick
    let ticksPerSecond = 60
    /// 时 = 2500 tick
    let ticksPerHour = 2500
    /// 天 = 60000 tick
    let ticksPerDay = 60000
    /// 1季度15天
    let ticksPerMonth = 15
    /// 年 = 900000 tick
    let ticksPerYear = 900000
    
    /// 饥饿值掉落tick
    let ticksPerHunger = 400
    

    
    /// 娱乐值
    let ticksPerJoyDrop = 600
    
    /// 总时间
    var totalTicks: Int = 0 {
           didSet {
               
               /// 天
               let oldDay = oldValue / ticksPerDay
               let newDay = totalTicks / ticksPerDay
               if oldDay != newDay {
                   NotificationCenter.default.post(name: .RMGameTimeDayChange, object: self)
               }

               /// 小时
               let oldHour = (oldValue / ticksPerHour) % 24
               let newHour = (totalTicks / ticksPerHour) % 24
               if oldHour != newHour {
                   NotificationCenter.default.post(name: .RMGameTimeHourChange, object: self)
               }
               
               /// 饥饿值
               let oldHunger = oldValue / ticksPerHunger
               let newHunger = totalTicks / ticksPerHunger
               if oldHunger != newHunger {
                   NotificationCenter.default.post(name: .RMGameTimeHungerTick, object: self)
               }
               
             
               
               // 娱乐掉落值
               let oldJoy = oldValue / ticksPerJoyDrop
               let newJoy = totalTicks / ticksPerJoyDrop
               if oldJoy != newJoy {
                   NotificationCenter.default.post(name: .RMGameTimeJoyTick, object: self)
               }
               
           }
       }
    
  
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = RMGameTime
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(timeID, isPrimary: true,isAutoIncrement: false)
        }
        
        case timeID
        case totalTime
        case timeScale
        case totalTicks
    }
    
    func hourTime() -> String {
        let newHour = (totalTicks / ticksPerHour) % 24
        return "\(newHour)\(textAction("Hour"))"
    }
    
    func formatRimWorldTime() -> String {
        
        let ticks = totalTicks
        let days = ticks / ticksPerDay

        let year = days / ticksPerSecond + 1
        let seasonIndex = (days % ticksPerSecond) / ticksPerMonth
        let dayInSeason = (days % ticksPerMonth) + 1

        let seasons = [textAction("Spring"), textAction("Summer"), textAction("Fall"), textAction("Winter")]
        let seasonName = seasons[seasonIndex]

        return "\(year)\(textAction("Year")) \(seasonName) \(dayInSeason)\(textAction("Day"))"
    }
}
