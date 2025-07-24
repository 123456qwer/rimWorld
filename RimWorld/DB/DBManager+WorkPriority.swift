//
//  DBManager+WorkPrioritySet.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 根据人物ID获取workPrioritySet
    func getWorkPriority(componentID:Int) -> WorkPriorityComponent {
        
        do{
            if let work: WorkPriorityComponent = try getWorkPrioritySetDB().getObject( fromTable: kWorkPriorityComponent, where: WorkPriorityComponent.Properties.componentID == componentID){
                return work
            }
            
        }catch {
            
        }
        
        return WorkPriorityComponent()
    }
    
    /// 更新工序
    func upDateWorkPriority(work:WorkPriorityComponent) {
        do {
            try getWorkPrioritySetDB().insertOrReplace(work, intoTable: kWorkPriorityComponent)
            ECSLogger.log("修改角色工作顺序成功")
        }catch {
            ECSLogger.log("修改角色工作顺序失败")
        }
    }
    
}
