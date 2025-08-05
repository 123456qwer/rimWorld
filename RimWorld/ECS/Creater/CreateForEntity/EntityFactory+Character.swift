//
//  EntityFactory+Character.swift
//  RimWorld
//
//  Created by wu on 2025/5/8.
//

import Foundation
extension EntityFactory {
    
    /// 创建乔丹角色
    func michaelJordan() -> RMEntity{
        
        /// 人物实体
        let characterEntity = RMEntity()
        characterEntity.type = kCharacter
        characterEntity.name = "Michael"
        
        /// 基础组件
        let character = BasicInfoComponent()
        character.nickName = "飞人"
        character.keyName = kMichaelJordan
        character.firstName = "Michael"
        character.lastName = "Jordan"
        character.textureName = kMichaelJordan
        character.title = "历史第一人"
        character.age = 62
        
        /// 工作状态组件
        let work = WorkPriorityComponent()
        work.initDataForName(kMichaelJordan)
        /// 技能组件
        let skill = SkillComponent()
        skill.initDataForName(kMichaelJordan)
        /// 位置
        let characterPoint = PositionComponent()
        characterPoint.x = 0
        characterPoint.y = 0
        characterPoint.z = 1
     
        /// 特性
        let trait = TraitComponent()
        let traitId1 = CharacterTrait.optimist.rawValue
        let traitId2 = CharacterTrait.nimble.rawValue
        let traitId3 = CharacterTrait.carefulShooter.rawValue
        let traitId4 = CharacterTrait.tough.rawValue
        trait.addTraits([traitId1,traitId2,traitId3,traitId4])
        
        
        /// 拥有的东西
        let owner = OwnershipComponent()
        /// 通用组件
        addCommonComponent(characterEntity)
        
        addComponent([character,work,skill,owner,characterPoint,trait], characterEntity)
       
        /// 抽雪茄时手指受伤
        if let bodyPartComponent = characterEntity.getComponent(ofType: BodyPartComponent.self){
            bodyPartComponent.rightFingers = 0
            bodyPartComponent.tongue = 70
            bodyPartComponent.rightArm = 110
            bodyPartComponent.leftArm = 105
        }
        
        
        self.michaelJordanForWeapon(characterEntity)
        self.michaelJordanForArmor(characterEntity)
        
        saveEntity(entity: characterEntity)
        return characterEntity
    }
    
    
    /// 创建岳飞
    func yueFei() -> RMEntity{
        
        /// 人物实体
        let entity = RMEntity()
        entity.type = kCharacter
        entity.name = "岳飞"

        /// 基础组件
        let character = BasicInfoComponent()
        character.nickName = "名将"
        character.keyName = kYueFei
        character.firstName = "Yue"
        character.lastName = "Fei"
        character.textureName = kYueFei
        character.title = "精忠报国"
        character.age = 218
        character.race = SpeciesType.android.rawValue
        
        /// 工作状态组件
        let work = WorkPriorityComponent()
        work.initDataForName(kYueFei)
        /// 技能组件
        let skill = SkillComponent()
        skill.initDataForName(kYueFei)
        /// 位置组件
        let characterPoint = PositionComponent()
        characterPoint.x = tileSize * 5
        characterPoint.y = 0
        characterPoint.z = 1
        /// 特性
        let trait = TraitComponent()
        let traitId1 = CharacterTrait.brawler.rawValue
        let traitId2 = CharacterTrait.fastLearner.rawValue
        let traitId3 = CharacterTrait.kind.rawValue
        trait.addTraits([traitId1,traitId2,traitId3])
      
        /// 拥有的东西
        let owner = OwnershipComponent()
        
        
        addCommonComponent(entity)
        addComponent([character,work,skill,characterPoint,trait,owner], entity)
        
        /// 
        if let bodyPartComponent = entity.getComponent(ofType: BodyPartComponent.self) {
            bodyPartComponent.leftLeg = 50
            bodyPartComponent.rightLeg = 70
            bodyPartComponent.stomach = 30
            bodyPartComponent.heart = 120
        }
        
        
        if let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self) {
            nutritionComponent.total = 150
            nutritionComponent.current = 150
            nutritionComponent.nutritionDecayPerTick = 0.1
        }
        
        self.yueFeiForGoods(entity)
        saveEntity(entity: entity)
        
        
        
        return entity
    }
    
    
}


/// 工具
extension EntityFactory {
    
    /// 人物通用组件
    private func addCommonComponent(_ entity: RMEntity){
        
        /// 健康
        let healthComponent = HealthComponent()
        /// 心情
        let emotionComponent = EmotionComponent()
        /// 能量
        let energyComponent = EnergyComponent()
        /// 获取区域
        let movementComponent = MovementBoundsComponent()
        

        /// 饮食、营养
        let nutritionComponent = NutritionComponent()
        /// 娱乐值
        let joyComponent = JoyComponent()
        /// 美观度
        let aestheticComponent = AestheticComponent()
        /// 舒适度
        let comfortComponent = ComfortComponent()
        /// 外出
        let outdooorComponent = OutdoorComponent()
        
        /// 身体部件
        let bodyPartComponent = BodyPartComponent()
        
        /// 当前行为
        let actionTypeComponent = ActionStateComponent()

        
        
        /// 负重
        let carryingComponent = CarryingCapacityComponent()
        /// 温度
        let temperatureComponent = ComfortTemperatureComponent()
        /// 防御组件
        let defenseComponent = DefenseComponent()
    
        /// 任务系统组件
        let taskComponent = TaskQueueComponent()
        
        /// 寻路系统
        let moveComponent = MoveComponent()
        
        /// 日志组件
        let logComponent = LogComponent()
        
        addComponent([healthComponent,emotionComponent,energyComponent,movementComponent,nutritionComponent,joyComponent,aestheticComponent,comfortComponent,outdooorComponent,bodyPartComponent,actionTypeComponent,carryingComponent,temperatureComponent,defenseComponent,taskComponent,moveComponent,logComponent], entity)
    }
    
    /// 添加组件，并将组件绑定到实体上
    func addComponent(_ components:[Component],
                              _ entity:RMEntity){
        for component in components {
            component.bindEntityID(entity.entityID)
            entity.addComponent(component)
        }
    }
}
