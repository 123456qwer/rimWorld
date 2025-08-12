//
//  EntityRemoveReason.swift
//  RimWorld
//
//  Created by wu on 2025/8/7.
//

import Foundation

/// 移除原因
protocol RemoveReason {}


/// 植物移除
struct TreeRemoveReason: RemoveReason {
    let entity: RMEntity
}

/// 矿产被移除
struct MineRemoveReason: RemoveReason {
    let entity: RMEntity
}

/// 存储区域移除
struct StorageRemoveReason: RemoveReason {
    let entity: RMEntity
}

/// 蓝图移除
struct BlueprintRemoveReason: RemoveReason {
    let entity: RMEntity
}

/// 移除种植区域
struct GrowingAreaRemoveReason: RemoveReason {
    let entity: RMEntity
}


