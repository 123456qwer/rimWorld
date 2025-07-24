//
//  EntityID.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

/// 实体 ID 类型定义
import Foundation
import SpriteKit

class RMEntity: NSObject {
    
    var node:RMBaseNode?
    
    /// 实体唯一标识
    var entityID:Int = -1

    /// 实体名称
    var name:String = ""
    
    /// 类型，比如：weapon，charcter等等
    var type:String = ""
    var components: [String: Component] = [:]
    
    
    override init() {
        entityID = DBManager.shared.getIdentifierID(nowId: entityID)
    }
    

    /// 添加组件
    func addComponent<T: Component>(_ component: T) {
        let key = "\(T.self)"
        components[key] = component
    }
    
    /// 移除组件
    func removeComponent<T: Component>(ofType type: T.Type) {
        let key = "\(T.self)"
        components.removeValue(forKey: key)
    }
    
    /// 获取组件
    func getComponent<T: Component>(ofType type: T.Type) -> T? {
        components["\(T.self)"] as? T
    }
    
    /// 获取所有组件
    func allComponents() -> [Component]{
        var tempCom:[Component] = []
        for (_, value) in components {
            tempCom.append(value)
        }
        return tempCom
    }

    
    /// 同步人物一些数据
    func syncCharacterStats(){
        
        if self.type != kCharacter { return }
        
        /// 防御
        let defenceComponent = self.getComponent(ofType: DefenseComponent.self) ?? DefenseComponent()
        /// 负重
        let carryingComponent = self.getComponent(ofType: CarryingCapacityComponent.self) ?? CarryingCapacityComponent()
        /// 温度
        let temperatureComponent = self.getComponent(ofType: ComfortTemperatureComponent.self) ?? ComfortTemperatureComponent()
        
        
        
        
        /// 所拥有的武器、挂件等
        if let ownershipComponent = self.getComponent(ofType: OwnershipComponent.self) {
            
            var removeOwneds:[RMEntity] = []
            for id in ownershipComponent.ownedEntityIDS {
                /// 添加武器、其他的
                let entity = DBManager.shared.getEntity(id)
                /// 武器、挂件
                if entity.type == kWeapon {
                    
                    /// 计算下总值
                    if let weaponComponent = entity.getComponent(ofType: WeaponComponent.self) {
                        carryingComponent.currentLoad += weaponComponent.weight
                    }
                    
                }else if entity.type == kArmor {
                    
                    /// 计算下总值
                    if let armorComponent = entity.getComponent(ofType: ArmorComponent.self) {
                        
                        defenceComponent.sharpArmor = armorComponent.sharpArmor + defenceComponent.sharpArmor
                        defenceComponent.bluntArmor = armorComponent.bluntArmor + defenceComponent.bluntArmor
                        defenceComponent.heatArmor  = armorComponent.heatArmor + defenceComponent.heatArmor
                        carryingComponent.currentLoad += armorComponent.weight
                        temperatureComponent.maxTolerableTemp += armorComponent.maxTemperatureBonus
                        temperatureComponent.minTolerableTemp += armorComponent.minTemperatureBonus
                    }
                }else if entity.type == kMedicine {
                    
                    /// 药品重量
                    if let medicineComponent = entity.getComponent(ofType: MedicalKitComponent.self) {
                        carryingComponent.currentLoad += medicineComponent.weight
                    }
                }
                
                /// 删除依赖
                if entity.type == kWood {
                    removeOwneds.append(entity)
                }
            }
            
            /// 木头什么的，直接删除
            for entity in removeOwneds {
                OwnerShipTool.removeOwner(owned: entity, owner: self)
            }
        }
        
    }
    
    
    
}



