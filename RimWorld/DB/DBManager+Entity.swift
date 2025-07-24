//
//  DBManager+Entity.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 更新Or新增实体
    func upDateEntity(entity:EntityData) {
        do {
            entity.entityID = getIdentifierID(nowId: entity.entityID)
            try getSkillDB().insertOrReplace(entity, intoTable: kAllEntityData)
//            ECSLogger.log("修改实体成功，表名：\(entity.tableName)")
        }catch {
//            ECSLogger.log("修改实体失败，表名：\(entity.tableName)")
        }
    }
    
    /// 删除实体
    func removeEntity(entityID: Int) {
        do {
            try getEneityDB().delete(fromTable: kAllEntityData, where: EntityData.Properties.entityID == entityID)
            ECSLogger.log("删除实体成功")
        }catch {
            ECSLogger.log("删除实体失败")
        }
    }
    
    /// 获取所有实体，以及初始化实体对应的node
    func getAllEntity() -> [RMEntity]{
        do{
            let entitys:[EntityData] = try getEneityDB().getObjects( fromTable: kAllEntityData)
            return getEntitys(entitys)
        } catch {
            ECSLogger.log("获取实体失败：\(error)")
            return []
        }
    }
    
    /// 获取角色实体数据
    func getCharacterEntitys() -> [RMEntity] {
        do{
            let entitys:[EntityData] = try getEneityDB().getObjects( fromTable: kAllEntityData, where: EntityData.Properties.type == kCharacter)
            return getEntitys(entitys)
        } catch {
            ECSLogger.log("获取角色实体失败：\(error)")
            return []
        }
    }
    
    /// 根据EntityID获取单独的实体
    func getEntity(_ entityID:Int) -> RMEntity {
        do{
            if let entity:EntityData = try getEneityDB().getObject( fromTable: kAllEntityData, where: EntityData.Properties.entityID == entityID){
                return getEntity(entity)
            }
        } catch {
            ECSLogger.log("获取角色实体失败：\(error)")
        }
        return RMEntity()
    }
    
    /// 获取具体武器实体
    func getWeaponEntity(_ entityID: Int) -> RMEntity {
        do {
            if let entity:EntityData = try getEneityDB().getObject( fromTable: kAllEntityData, where: EntityData.Properties.entityID == entityID && EntityData.Properties.type == kWeapon){
                return getEntity(entity)
            }
        } catch {
            ECSLogger.log("获取武器实体失败：\(error)")
        }
        
        return RMEntity()
    }
    
}


/// Private
extension DBManager {
    /// 获取所有实体
    private func getEntitys(_ entityDatas:[EntityData]) -> [RMEntity] {
        
        var entitys:[RMEntity] = []

        for entityData in entityDatas {
            /// 任意实体
            let entity = getEntity(entityData)
            entitys.append(entity)
        }
        
        return entitys
    }
    
    /// 获取单个实体
    private func getEntity(_ entityData: EntityData) -> RMEntity {
        let nodeBuilder = NodeBuilder()
        let entity = RMEntity()
        let components = DataCoder.decodeEntityComponents(entityData.data)
                
        for component in components {
            entity.addComponent(component)
        }
        entity.entityID = entityData.entityID
        entity.type = entityData.type
        entity.name = entityData.name
        entity.syncCharacterStats()
        
        return entity
    }
}
