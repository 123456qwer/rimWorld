//
//  DBManager+Weapon.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    func getAllWeapons() -> [WeaponComponent] {
        
        do{
            let weapons:[WeaponComponent] = try getWeaponDB().getObjects( fromTable: kWeaponComponent)
            return weapons
        }catch {
            return []
        }
        
    }
    
    @discardableResult
    func updateWeapon(weapon:WeaponComponent) -> Int{
        do{
            
            // 如果没有自增 ID，我们手动生成一个标识符
            weapon.componentID = getIdentifierID(nowId: weapon.componentID)
            
            try getWeaponDB().insertOrReplace(weapon, intoTable: kWeaponComponent)
            
            ECSLogger.log("修改武器数据成功：\(weapon.textureName)")
            return weapon.componentID
        }catch{
            ECSLogger.log("修改武器数据失败：\(weapon.textureName)")
            return -1
        }
    }
    
}
