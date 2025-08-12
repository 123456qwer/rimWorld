//
//  Harvest+Mine.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import Foundation

/// 矿产
extension ResourceHarvestSystem {
    
    func removeMine (params: MineRemoveReason) {
        let targetEntity = params.entity
        /// 矿坐标
        let targetPoint = PositionTool.nowPosition(targetEntity)
        
        /// 生成的矿产
        let count = EntityInfoTool.currentHarvestAmountForMine(entity: targetEntity)
        
        ///
        if count > 0 {
            
            let params = OreParams(oreCount: count,
                                   materialType: .marble)
            /// 创建矿产实体
            RMEventBus.shared.requestCreateEntity(type: kOre,
                                                  point: targetPoint,
                                                  params: params)
        }
    }
}
