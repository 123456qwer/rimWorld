//
//  SkillComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift


/// 人物技能基础信息组件
final class SkillComponent: Component,TableCodable {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    // 数据库存储字段（每个技能都有值和偏好等级）
    /// 射击
    var shootingValue: Int = 0
    var shootingPreference: Int = 0
    /// 格斗
    var meleeValue: Int = 0
    var meleePreference: Int = 0
    /// 建造
    var constructionValue: Int = 0
    var constructionPreference: Int = 0
    /// 采矿
    var miningValue: Int = 0
    var miningPreference: Int = 0
    /// 烹饪
    var cookingValue: Int = 0
    var cookingPreference: Int = 0
    /// 种植
    var growingValue: Int = 0
    var growingPreference: Int = 0
    /// 驯兽
    var animalHandlingValue: Int = 0
    var animalHandlingPreference: Int = 0
    /// 手工
    var craftingValue: Int = 0
    var craftingPreference: Int = 0
    /// 艺术
    var artValue: Int = 0
    var artPreference: Int = 0
    /// 医疗
    var medicineValue: Int = 0
    var medicinePreference: Int = 0
    /// 社交
    var socialValue: Int = 0
    var socialPreference: Int = 0
    /// 智识
    var intellectualValue: Int = 0
    var intellectualPreference: Int = 0
    
    enum CodingKeys:String, CodingTableKey{
        typealias Root = SkillComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        case entityID
        case componentID
        case shootingValue, shootingPreference
        case meleeValue, meleePreference
        case constructionValue, constructionPreference
        case miningValue, miningPreference
        case cookingValue, cookingPreference
        case growingValue, growingPreference
        case animalHandlingValue, animalHandlingPreference
        case craftingValue, craftingPreference
        case artValue, artPreference
        case medicineValue, medicinePreference
        case socialValue, socialPreference
        case intellectualValue, intellectualPreference
    }
    
    /// 快捷访问
    private var skillKeyPaths: [WritableKeyPath<SkillComponent, Int>] = [
        \.shootingValue,
         \.meleeValue,
        \.constructionValue,
        \.miningValue,
        \.cookingValue,
        \.growingValue,
        \.animalHandlingValue,
        \.craftingValue,
        \.artValue,
        \.medicineValue,
        \.socialValue,
        \.intellectualValue,
    ]
    
    
    
    lazy var nameMehtodMap: [String: () -> Void] = [kMichaelJordan: MichaelJordan,
                                                           kYueFei:YueFei]
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
}


extension SkillComponent {
    
    /// 根据工作类型返回工作星度
    func preferenceCountForWork(workType:WorkType) -> Int {
        
        var preference = 0
        switch workType {
        case .Firefighting:
            // 灭火
            break
        case .SelfCare:
            // 就医
            break
        case .Doctor:
            // 医生
            preference = medicinePreference
            break
        case .Rest:
            // 休养
            break
        case .Basic:
            // 基本
            break
        case .Supervise:
            // 监管
            preference = socialPreference
            break
        case .AnimalHandling:
            // 驯兽
            preference = animalHandlingPreference
            break
        case .Cooking:
            // 烹饪
            preference = cookingPreference
            break
        case .Hunting:
            // 狩猎
            preference = shootingPreference
            break
        case .Building:
            // 建造
            preference = constructionPreference
            break
        case .Growing:
            // 种植
            preference = growingPreference
            break
        case .Mining:
            // 采矿
            preference = miningPreference
            break
        case .Cutting:
            // 割除
            preference = growingPreference
            break
        case .Smithing:
            // 锻造
            preference = craftingPreference
            break
        case .Tailoring:
            // 缝纫
            preference = craftingPreference
            break
        case .Art:
            // 艺术
            preference = artPreference
            break
        case .Crafting:
            // 制作
            preference = craftingPreference
            break
        case .Hauling:
            // 搬运
            break
        case .Cleaning:
            // 清洁
            break
        case .Research:
            // 研究
            preference = intellectualPreference
            break
        @unknown default:
            break
        }

        
        return preference
    }
   
    
    /// 根据技能类型返回工作星度
    func preferenceCountForSkill(skillType:SkillType) -> Int {
        
        var preferenceCount = 0
        
        switch skillType {
        case .Shooting:
            preferenceCount = self.shootingPreference
        case .Melee:
            preferenceCount = self.meleePreference
        case .Construction:
            preferenceCount = self.constructionPreference
        case .Mining:
            preferenceCount = self.miningPreference
        case .Cooking:
            preferenceCount = self.cookingPreference
        case .Growing:
            preferenceCount = self.growingPreference
        case .AnimalHandling:
            preferenceCount = self.animalHandlingPreference
        case .Crafting:
            preferenceCount = self.craftingPreference
        case .Art:
            preferenceCount = self.artPreference
        case .Medicine:
            preferenceCount = self.medicinePreference
        case .Social:
            preferenceCount = self.socialPreference
        case .Intellectual:
            preferenceCount = self.intellectualPreference
        }

        return preferenceCount
    }
    
    /// 根据技能类型返回工作熟练度
    func valueCountForSkill(skillType:SkillType) -> Int {
        
        var preferenceCount = 0
        
        switch skillType {
        case .Shooting:
            preferenceCount = self.shootingValue
        case .Melee:
            preferenceCount = self.meleeValue
        case .Construction:
            preferenceCount = self.constructionValue
        case .Mining:
            preferenceCount = self.miningValue
        case .Cooking:
            preferenceCount = self.cookingValue
        case .Growing:
            preferenceCount = self.growingValue
        case .AnimalHandling:
            preferenceCount = self.animalHandlingValue
        case .Crafting:
            preferenceCount = self.craftingValue
        case .Art:
            preferenceCount = self.artValue
        case .Medicine:
            preferenceCount = self.medicineValue
        case .Social:
            preferenceCount = self.socialValue
        case .Intellectual:
            preferenceCount = self.intellectualValue
        }

        return preferenceCount
    }
}


/// 初始化方法
extension SkillComponent {
    
    /// 根据名字
    func initDataForName(_ keyName: String){
        nameMehtodMap[keyName]?()
    }
    
    /// 迈克尔乔丹
    func MichaelJordan(){
        
        shootingValue = 12
        shootingPreference = 2
        
        meleeValue = 5
        meleePreference = 2
        
        constructionValue = 1
        constructionPreference = 0
        
        miningValue = -1
        miningPreference = -1
        
        cookingValue = 2
        cookingPreference = 0
        
        growingValue = -1
        growingPreference = -1
        
        animalHandlingValue = 8
        animalHandlingPreference = 1
        
        craftingValue = 2
        craftingPreference = 0
        
        artValue = 10
        artPreference = 1
        
        medicineValue = 1
        medicinePreference = 0
        
        socialValue = 15
        socialPreference = 2
        
        intellectualValue = 10
        intellectualPreference = 1
    }
    
    /// 岳飞
    func YueFei(){
        
        shootingValue = 12
        shootingPreference = 2
        
        meleeValue = 12
        meleePreference = 2
        
        constructionValue = 10
        constructionPreference = 2
        
        miningValue = 1
        miningPreference = 0
        
        cookingValue = 0
        cookingPreference = -1
        
        growingValue = 1
        growingPreference = 0
        
        animalHandlingValue = 1
        animalHandlingPreference = 0
        
        craftingValue = 2
        craftingPreference = 0
        
        artValue = 1
        artPreference = 0
        
        medicineValue = 1
        medicinePreference = 0
        
        socialValue = 1
        socialPreference = 0
        
        intellectualValue = 5
        intellectualPreference = 2
    }
}
