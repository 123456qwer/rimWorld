//
//  Constont.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation

/// 底部操作栏高度
let kBottomActionBarHeight = 22.0
/// 底部安全区域
let kSafeBottom = 21.0
/// 左侧安全区域
let kSafeLeft = 44.0

/// 各自区域大小
let tileSize = 32.0

/// 按钮横向内边距
let kBtnHorizontalPadding = 4.0

/// Z计算基准
let maxZpoint = 100000.0


// MARK: - 组件类型名称 -

/// 所有角色对话组件
let kEventSocialLogComponent = "EventSocialLogComponent"
/// 所有角色战斗记录组件
let kEventBattleLogComponent = "EventBattleLogComponent"


/// 角色基础数据组件
let kBasicInfoComponent = "BasicInfoComponent"
/// 工作优先级组件
let kWorkPriorityComponent = "WorkPriorityComponent"
/// 角色技能组件
let kSkillComponent = "SkillComponent"
/// 武器组件
let kWeaponComponent = "WeaponComponent"
/// 护甲组件
let kArmorComponent = "ArmorComponent"
/// 坐标组件
let kPositionComponent = "PositionComponent"
/// 持有其他实体的组件
let kOwnershipComponent = "OwnershipComponent"
/// 被持有的组件标记
let kOwnedComponent = "OwnedComponent"
/// 健康组件
let kHealthComponent = "HealthComponent"
/// 心情组件
let kEmotionComponent = "EmotionComponent"
/// 能量组件
let kEnergyComponent = "EnergyComponent"
/// 移动空间组件
let kMovementBoundsComponent = "MovementBoundsComponent"
/// 当前行为组件
let kActionStateComponent = "ActionStateComponent"
/// 特性组件
let kTraitComponent = "TraitComponent"
/// 饮食营养组件
let kNutritionComponent = "NutritionComponent"
/// 娱乐组件
let kJoyComponent = "JoyComponent"
/// 美观度组件
let kAesthetiComponent = "AestheticComponent"
/// 舒适度组件
let kComfortComponent = "ComfortComponent"
/// 外出组件
let kOutdoorComponent = "OutdoorComponent"
/// 社交组件
let kSocialComponent = "SocialComponent"
/// 身体部件组件
let kBodyPartComponent = "BodyPartComponent"
/// 负重组件
let kCarryingCapacityComponent = "CarryingCapacityComponent"
/// 温度组件
let kComfortTemperatureComponent = "ComfortTemperatureComponent"
/// 防御组件
let kDefenseComponent = "DefenseComponent"
/// 树组件
let kPlantBasicInfoComponent = "PlantBasicInfoComponent"
/// 木头组件
let kWoodBasicInfoComponent = "WoodBasicInfoComponent"
/// 任务队列组件
let kTaskQueueComponent = "TaskQueueComponent"
/// 寻路组件系统
let kMoveComponent = "MoveComponent"
/// 存储区域
let kStorageInfoComponent = "StorageInfoComponent"
/// 蓝图组件
let kBlueprintComponent = "BlueprintComponent"

/// 搬运状态组件
let kHaulableComponent = "HaulableComponent"
/// 日志组件
let kLogComponent = "LogComponent"



/// 所有实体表
let kAllEntityData = "AllEntityData"



/// 可交互实体
let kMedicalKitComponent = "MedicalKitComponent"

/// 时间控件
let kRMTime = "RMTime"

/// 映射表
let componentTypeMap: [String: Decodable.Type] = [
    
    kBasicInfoComponent: BasicInfoComponent.self,
    kWorkPriorityComponent: WorkPriorityComponent.self,
    kSkillComponent: SkillComponent.self,
    kWeaponComponent: WeaponComponent.self,
    kPositionComponent: PositionComponent.self,
    kOwnershipComponent: OwnershipComponent.self,
    kOwnedComponent: OwnedComponent.self,
    kHealthComponent: HealthComponent.self,
    kEmotionComponent: EmotionComponent.self,
    kEnergyComponent: EnergyComponent.self,
    kMovementBoundsComponent: MovementBoundsComponent.self,
    kActionStateComponent:ActionStateComponent.self,
    kTraitComponent:TraitComponent.self,
    kNutritionComponent:NutritionComponent.self,
    kJoyComponent:JoyComponent.self,
    kAesthetiComponent: AestheticComponent.self,
    kComfortComponent: ComfortComponent.self,
    kOutdoorComponent: OutdoorComponent.self,
    kSocialComponent: SocialComponent.self,
    kEventSocialLogComponent: EventSocialLogComponent.self,
    kEventBattleLogComponent:EventBattleLogComponent.self,
    kBodyPartComponent:BodyPartComponent.self,
    kCarryingCapacityComponent: CarryingCapacityComponent.self,
    kComfortTemperatureComponent: ComfortTemperatureComponent.self,
    kDefenseComponent: DefenseComponent.self,
    kArmorComponent: ArmorComponent.self,
    kMedicalKitComponent: MedicalKitComponent.self,
    kRMTime:RMGameTime.self,
    kPlantBasicInfoComponent:PlantBasicInfoComponent.self,
    kTaskQueueComponent:TaskQueueComponent.self,
    kMoveComponent:MoveComponent.self,
    kWoodBasicInfoComponent:WoodBasicInfoComponent.self,
    kStorageInfoComponent:StorageInfoComponent.self,
    kHaulableComponent:HaulableComponent.self,
    kLogComponent:LogComponent.self,
    kBlueprintComponent:BlueprintComponent.self,
]

// MARK: - 实体类型 -
/// 角色
let kCharacter = "character"
/// 武器
let kWeapon = "weapon"
/// 护甲
let kArmor = "armor"
/// 树
let kTree = "tree"
/// 蓝图
let kBlueprint = "bluePrint"


/// 物品
/// 医药
let kMedicine = "Medicine"
/// 木头
let kWood = "Wood"


/// 食物
/// 鸡腿
let kChicken = "Chicken"



// MARK: - 角色名字 -
/// 乔丹
let kMichaelJordan = "MichaelJordan"
/// 岳飞
let kYueFei = "YueFei"



// MARK: - 区域 -
let kSaveArea = "SaveArea"
