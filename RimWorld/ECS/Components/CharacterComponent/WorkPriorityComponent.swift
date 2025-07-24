//
//  WorkPriorityComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import WCDBSwift

/// 工作优先级组件
final class WorkPriorityComponent: Component,TableCodable {
    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    /** 工作状态设定 */
    /// 灭火
    var firefighting:Int = 3
    /// 就医
    var selfCare:Int = 3
    /// 医生
    var doctor:Int = 3
    /// 休养
    var rest:Int = 3
    /// 基本
    var basic:Int = 3
    /// 监管
    var supervise:Int = 3
    /// 驯兽
    var animalHandling:Int = 3
    /// 烹饪
    var cooking:Int = 3
    /// 狩猎
    var hunting:Int = 3
    /// 建造
    var building:Int = 3
    /// 种植
    var growing:Int = 3
    /// 采矿
    var mining:Int = 3
    /// 割除
    var cutting:Int = 3
    /// 锻造
    var smithing:Int = 3
    /// 缝纫
    var tailoring:Int = 3
    /// 艺术
    var art:Int = 3
    /// 制作
    var crafting:Int = 3
    /// 搬运
    var hauling:Int = 3
    /// 清洁
    var cleaning:Int = 3
    /// 研究
    var research:Int = 3
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WorkPriorityComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case entityID
        case componentID
        /// 灭火
        case firefighting
        /// 就医
        case selfCare
        /// 医生
        case doctor
        /// 休养
        case rest
        /// 基本
        case basic
        /// 监管
        case supervise
        /// 驯兽
        case animalHandling
        /// 烹饪
        case cooking
        /// 狩猎
        case hunting
        /// 建造
        case building
        /// 种植
        case growing
        /// 采矿
        case mining
        /// 割除
        case cutting
        /// 锻造
        case smithing
        /// 缝纫
        case tailoring
        /// 艺术
        case art
        /// 制作
        case crafting
        /// 搬运
        case hauling
        /// 清洁
        case cleaning
        /// 研究
        case research
    }
    
    
    /// 快捷访问
    private var workKeyPaths: [WritableKeyPath<WorkPriorityComponent, Int>] = [
        \.firefighting,
        \.selfCare,
        \.doctor,
        \.rest,
        \.basic,
        \.supervise,
        \.animalHandling,
        \.cooking,
        \.hunting,
        \.building,
        \.growing,
        \.mining,
        \.cutting,
        \.smithing,
        \.tailoring,
        \.art,
        \.crafting,
        \.hauling,
        \.cleaning,
        \.research
    ]
    
    func bindEntityID(_ bindEntityID: Int) {
        entityID = bindEntityID
    }
    
    lazy var nameMehtodMap: [String: () -> Void] = [kMichaelJordan: MichaelJordan,
                                                           kYueFei:YueFei]

}

/// 初始化
extension WorkPriorityComponent {
    /// 根据名字
    func initDataForName(_ keyName: String){
        nameMehtodMap[keyName]?()
    }
    
    /// 迈克尔乔丹
    func MichaelJordan(){
        mining = -1
        growing = -1
    }
    
    /// 岳飞
    func YueFei(){
        cooking = -1
    }
}

extension WorkPriorityComponent {
    
    
    /// 工作优先级列表
    func getWorkPriorityArr() -> [Int] {
        return workKeyPaths.map { self[keyPath: $0] }
    }
    

    
    /// 更新工作优先级
    func updateWorkPriority(for index: Int, value: Int) {
        switch index {
        case 0:
            self.firefighting = value
        case 1:
            self.selfCare = value
        case 2:
            self.doctor = value
        case 3:
            self.rest = value
        case 4:
            self.basic = value
        case 5:
            self.supervise = value
        case 6:
            self.animalHandling = value
        case 7:
            self.cooking = value
        case 8:
            self.hunting = value
        case 9:
            self.building = value
        case 10:
            self.growing = value
        case 11:
            self.mining = value
        case 12:
            self.cutting = value
        case 13:
            self.smithing = value
        case 14:
            self.tailoring = value
        case 15:
            self.art = value
        case 16:
            self.crafting = value
        case 17:
            self.hauling = value
        case 18:
            self.cleaning = value
        case 19:
            self.research = value
        default:
            break
        }
        
        DBManager.shared.upDateWorkPriority(work: self)
    }
    
 
    
}
