//
//  DBManager+Skill.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift

extension DBManager {
    
    /// 根据人物ID获取workPrioritySet
    func getSkill(componentID:Int) -> SkillComponent {
        
        do{
            if let skill: SkillComponent = try getSkillDB().getObject( fromTable: kSkillComponent, where: SkillComponent.Properties.componentID == componentID){
                return skill
            }
            
        }catch {
            
        }
        
        return SkillComponent()
    }
    
    /// 更新工序
    func upDateSkill(skill:SkillComponent) {
        do {
            try getSkillDB().insertOrReplace(skill, intoTable: kSkillComponent)
            ECSLogger.log("修改角色技能成功")
        }catch {
            ECSLogger.log("修改角色技能顺序失败")
        }
    }
    
}
