//
//  Factory+Params.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 所有实体的参数都遵循这个协议
protocol EntityCreationParams {}

// MARK: 蓝图参数
struct BlueprintParams: EntityCreationParams {
    let size: CGSize
    let materials: [String: Int]
    let type: BlueprintType
    let totalBuildPoint: Double
}

// MARK: 存储区域参数
struct StorageParams: EntityCreationParams {
    let size: CGSize
}

// MARK: 种植区域参数
struct GrowingParams: EntityCreationParams {
    let size: CGSize
    let cropType: RimWorldCrop
}

// MARK: 木头参数
struct WoodParams: EntityCreationParams {
    let woodCount: Int
    /// 如果有，直接关联（搬运，从仓库中取出，有剩余时，创建新的，需要直接关联仓库）
    var superEntity: Int = -1
    /// 对应存储的位置
    var saveIndex: Int = -1
}


// MARK: 矿石参数
struct OreParams: EntityCreationParams {
    let oreCount: Int
    /// 如果有，直接关联（搬运，从仓库中取出，有剩余时，创建新的，需要直接关联仓库）
    var superEntity: Int = -1
    /// 对应存储的位置
    var saveIndex: Int = -1
    /// 材质
    var materialType: MaterialType = .marble
}


// MARK: 植物
struct PlantParams: EntityCreationParams {
    /// 种植区域ID
    let ownerId: Int
    
    /// 类型
    let cropType: RimWorldCrop
    
    /// 生成位置
    let saveKey: Int
}

// MARK: 斧头
struct AXParams: EntityCreationParams {
    /// 植物ID
    let ownerId: Int
}

// MARK: 镐子
struct MineParams: EntityCreationParams {
    /// 矿物
    let ownerId: Int
}

// MARK: 手
struct HandParams: EntityCreationParams {
    /// 植物ID
    let ownerId: Int
}

// MARK: 墙参数
struct WallParams: EntityCreationParams {
    /// 类型材质
    let material: MaterialType
    /// texture （直接传进来，省的在判断了）
    let wallTexture: String
    /// 类型
    let type: String
}
