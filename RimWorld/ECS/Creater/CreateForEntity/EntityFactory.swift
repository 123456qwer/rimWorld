//
//  EntityFactory.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation

/// 创建和存储实体
class EntityFactory{
    
    public static let shared = EntityFactory()
    
    private var characterFactoryMap: [String: () -> RMEntity] = [:]
    
    init() {
        characterFactoryMap = [kMichaelJordan:michaelJordan
                               ,kYueFei:yueFei]
    }

    /// 创建实体
    func createCharacterEntity(_ keyName: String) -> RMEntity{
        return characterFactoryMap[keyName]?() ?? RMEntity()
    }
    
    /// 添加实体到数据库
    func saveEntity(entity: RMEntity){
        
        let components = entity.allComponents()
        for component in components {
            entity.addComponent(component)
        }
        
        var point = CGPoint(x: 0, y: 0)
        if let pointComponent = entity.getComponent(ofType: PositionComponent.self){
            point = CGPoint(x: Int(pointComponent.x), y: Int(pointComponent.y))
        }
        
        saveEntity(type: entity.type,
                   position: point,
                   entity: entity)
    }
    
    /// 从数据库中移除实体
    func removeEntity(entity: RMEntity) {
        DBManager.shared.removeEntity(entityID: entity.entityID)
    }
    
    /// 存储实体
    private func saveEntity(type:String,
                    position:CGPoint,
                    entity:RMEntity){
        
        let data = DataCoder.encodeEntityComponents(entity)
//        let dic = DataCoder.decodeEntityComponents(data!)

        let entityData = EntityData()
        entityData.entityID = entity.entityID
        entityData.data = data ?? Data()
        entityData.type = type
        entityData.name = entity.name
        DBManager.shared.upDateEntity(entity: entityData)
    }
}
