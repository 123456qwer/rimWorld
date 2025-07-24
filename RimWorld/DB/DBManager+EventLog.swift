//
//  DBManager+EventLog.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 更新角色对话表
    func updateEventLog (_ eventLog: EventSocialLogComponent) {
        do {
            eventLog.componentID = getIdentifierID(nowId: eventLog.componentID)
            try getEventLogDB().insertOrReplace(eventLog, intoTable: kEventSocialLogComponent)
        } catch {
            
        }
    }
    
    /// 获取角色对话事件表
    func getEventLog () -> EventSocialLogComponent {
        let eventLog = EventSocialLogComponent()
        do {
            if let eventLog: EventSocialLogComponent = try getEventLogDB().getObject( fromTable: kEventSocialLogComponent){
                return eventLog
            }
        } catch {
            
        }
        return eventLog
    }
    

    
    
}
