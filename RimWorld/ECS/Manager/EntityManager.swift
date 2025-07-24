//
//  EntityManager.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

/// 实体管理器
import Foundation

class EntityManager {
    
    /// 所有的实体
    private var entities: [RMEntity] = []
    
    
    
    /// 有能量组件的实体
    private var entitiesAbleEnergy: Set<RMEntity> = []
    
    /// 从属关系映射
    private var rmEntityNodeMap:[Int: RMBaseNode] = [:]
    
    /// 实体
    private var rmEntityMap:[Int: RMEntity] = [:]
    
    
    // 快照
    /// 删除的实体
    private var entitiesToRemove: [RMEntity] = []
    // 快照
    /// 新增的实体
    private var entitiesToAdd: [RMEntity] = []
    
    
    init (){
        /// 初始化实体
        entities = DBManager.shared.getAllEntity()
        let builder = NodeBuilder()
        for entity in entities {
    
            let node = builder.buildNode(for: entity)
            rmEntityNodeMap[entity.entityID] = node
            rmEntityMap[entity.entityID] = entity
            entity.node = node
            node.rmEntity = entity
        }
        
        
    }
    
  
    
    
    /// 添加实体
    func addEntity(_ entity: RMEntity) {
        entities.append(entity)
        rmEntityNodeMap[entity.entityID] = entity.node
        rmEntityMap[entity.entityID] = entity
        entitiesToAdd.append(entity)
    }
    
    /// 移除实体
    func removeEntity(_ entity: RMEntity) {
        if let index = entities.firstIndex(where: { $0 === entity}){
            entities.remove(at: index)
        }
        rmEntityNodeMap.removeValue(forKey: entity.entityID)
        rmEntityMap.removeValue(forKey: entity.entityID)
        entitiesToRemove.append(entity)
        
        
    }
    
    
    /// 获取所有实体
    func allEntities() -> [RMEntity] {
        return entities
    }
    
    /// 获取所有含能量组件的实体
    func entitiesWithEnergy() -> Set<RMEntity> {
        return entitiesAbleEnergy
    }

    
    /// 获取实体对应的Node
    func getEntityNode(_ entityId: Int) -> RMBaseNode? {
        return rmEntityNodeMap[entityId]
    }
    
    /// 获取实体
    func getEntity(_ entityId: Int) -> RMEntity? {
        return rmEntityMap[entityId]
    }
}


/// 持久化
extension EntityManager {
    
    /// 存储数据到本地数据库
    func save() {
        
        /// 更新新数据
        let entityFactory = EntityFactory()
        for entity in entities {
            entityFactory.saveEntity(entity: entity)
        }
        
        /// 删除快照中标记为移除的数据
        for entity in entitiesToRemove {
            entityFactory.removeEntity(entity: entity)
        }
    }
    
   
    
}


    

    

