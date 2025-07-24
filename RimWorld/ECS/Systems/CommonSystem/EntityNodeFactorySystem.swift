//
//  CreateNodeSystem.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import Combine
/// 创建Node的管理者
class EntityNodeFactorySystem: System {
    
    var ecsManager:ECSManager
    var cancellables = Set<AnyCancellable>()

    
    init(ecsManager: ECSManager) {
        self.ecsManager = ecsManager        
    }
    
    
    func createEntity(_ type: String,
                      _ point: CGPoint,
                      _ size:CGSize?,
                      _ subContent:[String:Any]?) {
        
        if type == kWood {
            createWood(point,subContent!["haulCount"] as! Int)
        }else if type == kSaveArea{
            createSaveArea(point, size: size)
        }else if type == kBlueprint {
            createBlueprint(point, size: size,sub: subContent)
        }
    }
    
    
    /// 创建木头
    func createWood(_ point:CGPoint,
                    _ count:Int){
        
        
        let entity = EntityFactory.shared.createWoodEntityWithoutSaving(point: point,count: count)
        
        createNodeAction(entity)
        
        /// 添加搬运任务
        RMEventBus.shared.requestHaulTask(entity)
    }
    
    
    /// 创建存储区域
    func createSaveArea(_ point:CGPoint,
                        size:CGSize?) {
        let entity = EntityFactory.shared.createSaveAreaEntityWithoutSaving(point: point, size: size)
        createNodeAction(entity)
    }
    
    
    /// 创建建造蓝图
    func createBlueprint(_ point:CGPoint,
                         size:CGSize?,
                         sub:[String:Any]?) {
        let material = sub!["material"] as! MaterialType
        let entity = EntityFactory.shared.createBlueprint(point: point, size: size!, material: material)
        createNodeAction(entity)
        
        RMEventBus.shared.requestBuildTask(entity)
    }
    
    
    /// 创建node和设置实体
    func createNodeAction(_ entity:RMEntity) {
        let nodeBuilder = NodeBuilder()
        entity.node = nodeBuilder.buildNode(for: entity)
        entity.node?.rmEntity = entity
        
        entity.node?.defaultXscale = entity.node?.xScale ?? 1
        entity.node?.defaultYscale = entity.node?.yScale ?? 1
        
        /// 创建完成，添加
        RMEventBus.shared.requestAddEntity(entity)
    }
}
