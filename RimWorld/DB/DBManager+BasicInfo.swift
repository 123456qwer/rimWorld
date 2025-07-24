//
//  DBManager+Character.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 新增、修改角色数据
    @discardableResult
    func updateBasicInfo(_ info: BasicInfoComponent) -> Int{
        do {
            // 如果没有自增 ID，我们手动生成一个标识符
            info.componentID = getIdentifierID(nowId: info.componentID)
            
            try getBasicInfoDB().insertOrReplace(info, intoTable: kBasicInfoComponent)
            ECSLogger.log("修改角色信息完毕：\(info.firstName) + \(info.lastName)")
            return info.componentID
         
        }catch{
            ECSLogger.log("更新角色数据失败： \(info.firstName + info.lastName)")
        }
        
        return 0
    }
    
    /// 获取所有角色
    func getAllCharacter() -> [BasicInfoComponent] {
        do{
            let characters = try getBasicInfoDB().getObjects( fromTable: kBasicInfoComponent) as [BasicInfoComponent]
            return characters
        }catch{
            ECSLogger.log("获取角色数据失败 \(error)")
        }
        
        return []
    }
    
}
