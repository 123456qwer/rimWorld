//
//  DBManager+Time.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 游戏时间
    func updateTimeInfo(_ time: RMGameTime) {
        do {
            
            try getTimeDB().insertOrReplace(time, intoTable: kRMTime)
//            ECSLogger.log("当前游戏时间：\(time.totalTime)，当前游戏时间倍率：\(time.timeScale)")
         
        }catch{
            ECSLogger.log("更新时间表失败")
        }
    }
    
    /// 获取时间
    func getTime() -> RMGameTime {
        do{
            if let time: RMGameTime = try getTimeDB().getObject( fromTable: kRMTime, where: RMGameTime.Properties.timeID == 1) {
                return time
            }
        }catch{
            ECSLogger.log("获取角色数据失败 \(error)")
        }
        
        return RMGameTime()
    }
}
