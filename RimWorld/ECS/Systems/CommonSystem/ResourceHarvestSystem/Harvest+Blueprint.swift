//
//  Harvest+Blueprint.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 移除蓝图
extension ResourceHarvestSystem {
    /// 移除蓝图
    func removeBlueprint(reason: BlueprintRemoveReason) {
        
        let targetEntity = reason.entity
        
        guard let blueComponent = targetEntity.getComponent(ofType: BlueprintComponent.self) else { return }
    
        /// 正常建造完成后的移除方法
        if blueComponent.isBuildFinish { return }
        
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        let alreadyMaterials = blueComponent.alreadyMaterials
        
        var index = 0
        let points = MathUtils.getSurroundingPoints(center: targetPoint, distance: tileSize)
        for (type,count) in alreadyMaterials {
            let materialType = MaterialType(rawValue: Int(type)!)
            if count > 0 {
                
                /// 如果大于0，要生成对应的子类实体，位置随机掉落
                var point = targetPoint
                if index < points.count {
                    point = points[index]
                }
                
                switch materialType {
                case .wood:
                    /// 创建木头
                    let params = HarvestParams(harvestCount: count)
                    RMEventBus.shared.requestCreateEntity(type: kWood, point: point, params: params)
                    
                default:
                    break
                }
                
            }
            
            index += 1
        }
        
    }
    
   
}
