//
//  DBManager.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import WCDBSwift




class DBManager: NSObject {
    
    public static let shared = DBManager()
    
    private let rimWordDBPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/RimWordDB"
    
    
    /// 人物基础
    private var basicInFo: Database?
    private var workPriority: Database?
    private var skill: Database?

    private var weapon: Database?
    private var entity: Database?
    
    private var eventLog: Database?
    
    private  var time: Database?
    
    private override init() {
        super.init()
        setupDatabases()
    }
    
    private func setupDatabases() {
        basicInFo = setupDatabase(at: rimWordDBPath, tableName: kBasicInfoComponent, tableType: BasicInfoComponent.self)
        workPriority = setupDatabase(at: rimWordDBPath, tableName: kWorkPriorityComponent, tableType: WorkPriorityComponent.self)
        skill = setupDatabase(at: rimWordDBPath, tableName: kSkillComponent, tableType: SkillComponent.self)
        weapon = setupDatabase(at: rimWordDBPath, tableName: kWeaponComponent, tableType: WeaponComponent.self)
        entity = setupDatabase(at: rimWordDBPath, tableName: kAllEntityData, tableType: EntityData.self)
        eventLog = setupDatabase(at: rimWordDBPath, tableName: kEventSocialLogComponent, tableType: EventSocialLogComponent.self)
        time = setupDatabase(at: rimWordDBPath, tableName: kRMTime, tableType: RMGameTime.self)
    }
    
    private func setupDatabase<T: TableCodable>(at path: String, tableName: String, tableType: T.Type) -> Database {
        let database = Database(at: path)
        
        do {
            if try !database.isTableExists(tableName) {
                try database.create(table: tableName, of: tableType)
                print("Table \(tableName) created successfully.")
            }
        } catch {
            print("Failed to create table or check existence: \(error)")
        }
        
        return database
    }
    
    
    /// 获取角色表
    func getBasicInfoDB() -> Database {
        guard let database = basicInFo else {
            fatalError("获取角色表失败")
        }
        return database
    }
    /// 获取工作顺序表
    func getWorkPrioritySetDB() -> Database {
        guard let database = workPriority else {
            fatalError("获取工序表失败 ")
        }
        return database
    }
    /// 获取角色技能表
    func getSkillDB() -> Database {
        guard let database = skill else {
            fatalError("获取技能表失败 ")
        }
        return database
    }
    /// 获取武器表
    func getWeaponDB() -> Database {
        guard let database = skill else {
            fatalError("获取武器表失败")
        }
        return database
    }
    /// 实体表
    func getEneityDB() -> Database {
        guard let database = entity else {
            fatalError("获取实体表失败")
        }
        return database
    }
    /// 获取对话事件表
    func getEventLogDB() -> Database {
        guard let database = eventLog else {
            fatalError("获取对话事件表失败")
        }
        return database
    }
    /// 获取对话事件表
    func getTimeDB() -> Database {
        guard let database = time else {
            fatalError("获取时间表失败")
        }
        return database
    }
    
    
    /// 自己生成唯一标识
    func getIdentifierID(nowId:Int) -> Int{
        if nowId == -1 {
            let timestamp = Int(Date().timeIntervalSince1970 * 1000) // 毫秒
            let randomSuffix = Int.random(in: 0..<1000)              // 三位随机数
            return timestamp * 1000 + randomSuffix
        }else{
            return nowId
        }
    }
}
