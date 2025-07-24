//
//  BodyPartComponent.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import WCDBSwift

/// 身体部件
final class BodyPartComponent: TableCodable, Component {
    
    /// 不同能力受到的身体部位影响及其权重映射
    let capacityInfluenceMap: [CapacityType: [(part: BodyPartType, weight: Float)]] = [

        // 疼痛（由大脑主要感知）
        .pain: [
            (.brain, 1.0)
        ],
        
        // 意识（主要由大脑控制）
        .consciousness: [
            (.brain, 0.6),
            (.skull, 0.2),
            (.neck, 0.2)
        ],
        
        // 移动能力（受双腿、脊椎等影响）
        .moving: [
            (.leftLeg, 0.3),
            (.rightLeg, 0.3),
            (.spine, 0.2),
            (.leftFoot, 0.1),
            (.rightFoot, 0.1)
        ],
        
        // 操作能力（受双臂、双手及脊椎影响）
        .manipulation: [
            (.leftArm, 0.25),
            (.rightArm, 0.25),
            (.leftHand, 0.15),
            (.rightHand, 0.15),
            (.spine, 0.2)
        ],
        
        // 语言能力（受舌头、下颌、大脑影响）
        .talking: [
            (.tongue, 0.4),
            (.jaw, 0.3),
            (.brain, 0.3)
        ],
        
        // 进食能力（受下颌、舌头、胃、食道区域影响）
        .eating: [
            (.jaw, 0.3),
            (.tongue, 0.2),
            (.stomach, 0.3),
            (.neck, 0.2)
        ],
        
        // 视觉能力（由双眼控制）
        .sight: [
            (.eyes, 0.8),
            (.brain, 0.2)
        ],
        
        // 听觉能力（由双耳控制）
        .hearing: [
            (.ears, 0.8),
            (.brain, 0.2)
        ],
        
        // 呼吸能力（由肺部和颈部控制）
        .breathing: [
            (.lungs, 0.7),
            (.neck, 0.3)
        ],
        
        // 血液过滤（由肾脏控制）
        .bloodFiltration: [
            (.kidneys, 1.0)
        ],
        
        // 血液循环（由心脏和血管系统主导）
        .bloodPumping: [
            (.heart, 0.8),
            (.spine, 0.2)
        ],
        
        // 消化能力（胃为主，肝脏和肠道/消化通道辅助）
        .digestion: [
            (.stomach, 0.5),
            (.liver, 0.5),
        ]
    ]

    let bodyPartKeyPathMap: [String: WritableKeyPath<BodyPartComponent, Int>] = [
        // 头部区域
        "head": \.head,
        "skull": \.skull,
        "brain": \.brain,
        "eyes": \.eyes,
        "ears": \.ears,
        "nose": \.nose,
        "jaw": \.jaw,
        "tongue": \.tongue,
        
        // 躯干区域
        "neck": \.neck,
        "torso": \.torso,
        "spine": \.spine,
        "heart": \.heart,
        "lungs": \.lungs,
        "liver": \.liver,
        "kidneys": \.kidneys,
        "stomach": \.stomach,
        
        // 上肢区域
        "leftArm": \.leftArm,
        "leftHand": \.leftHand,
        "leftFingers": \.leftFingers,
        "rightArm": \.rightArm,
        "rightHand": \.rightHand,
        "rightFingers": \.rightFingers,
        
        // 下肢区域
        "leftLeg": \.leftLeg,
        "leftFoot": \.leftFoot,
        "leftToes": \.leftToes,
        "rightLeg": \.rightLeg,
        "rightFoot": \.rightFoot,
        "rightToes": \.rightToes
    ]


    
    /// 自身唯一标识
    var componentID:Int = -1
    /// 所属实体
    var entityID:Int = -1
    
    // MARK: - 头部区域
    /// 头部
    var head: Int = 100
    /// 颅骨
    var skull: Int = 100
    /// 大脑
    var brain: Int = 100
    /// 眼睛
    var eyes: Int = 100
    /// 耳朵
    var ears: Int = 100
    /// 鼻子
    var nose: Int = 100
    /// 下颌
    var jaw: Int = 100
    /// 舌头
    var tongue: Int = 100

    // MARK: - 躯干区域
    /// 颈部
    var neck: Int = 100
    /// 胸部
    var torso: Int = 100
    /// 脊椎
    var spine: Int = 100
    /// 心脏
    var heart: Int = 100
    /// 肺
    var lungs: Int = 100
    /// 肝脏
    var liver: Int = 100
    /// 肾脏
    var kidneys: Int = 100
    /// 胃
    var stomach: Int = 100

    // MARK: - 上肢区域
    /// 左臂
    var leftArm: Int = 100
    /// 左手
    var leftHand: Int = 100
    /// 左手指
    var leftFingers: Int = 100
    /// 右臂
    var rightArm: Int = 100
    /// 右手
    var rightHand: Int = 100
    /// 右手指
    var rightFingers: Int = 100

    // MARK: - 下肢区域
    /// 左腿
    var leftLeg: Int = 100
    /// 左脚
    var leftFoot: Int = 100
    /// 左脚趾
    var leftToes: Int = 100
    /// 右腿
    var rightLeg: Int = 100
    /// 右脚
    var rightFoot: Int = 100
    /// 右脚趾
    var rightToes: Int = 100
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = BodyPartComponent
        static let objectRelationalMapping = TableBinding(CodingKeys.self){
            BindColumnConstraint(componentID, isPrimary: true,isAutoIncrement: false)
        }
        
        case componentID
        case entityID
        
        // 头部区域
        case head             /// 头部
        case skull            /// 颅骨
        case brain            /// 大脑
        case eyes             /// 眼睛
        case ears             /// 耳朵
        case nose             /// 鼻子
        case jaw              /// 下颌
        case tongue           /// 舌头

        // 躯干区域
        case neck             /// 颈部
        case torso            /// 胸部
        case spine            /// 脊椎
        case heart            /// 心脏
        case lungs            /// 肺
        case liver            /// 肝脏
        case kidneys          /// 肾脏
        case stomach          /// 胃

        // 上肢区域
        case leftArm          /// 左臂
        case leftHand         /// 左手
        case leftFingers      /// 左手指

        case rightArm         /// 右臂
        case rightHand        /// 右手
        case rightFingers     /// 右手指

        // 下肢区域
        case leftLeg          /// 左腿
        case leftFoot         /// 左脚
        case leftToes         /// 左脚趾

        case rightLeg         /// 右腿
        case rightFoot        /// 右脚
        case rightToes        /// 右脚趾
    }
    
    func bindEntityID(_ bindEntityID: Int) { entityID = bindEntityID }
}


///
extension BodyPartComponent {
    
    /// 根据部位名称获取部位对应数值
    func getPartValue(key: String) -> Int {
        var value = 0
        if let keyPath = bodyPartKeyPathMap[key] {
            value = self[keyPath: keyPath]
        }
        return value
    }
    
}
