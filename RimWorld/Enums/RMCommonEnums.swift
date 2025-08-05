//
//  RMEnums.swift
//  RimWorld
//
//  Created by wu on 2025/5/10.
//

import Foundation

/// 实体质量枚举
enum RimWorldEntityQuality: Int, CaseIterable {
    case awful = 1       // 劣质
    case poor = 2        // 较差
    case normal = 3      // 普通
    case good = 4        // 良好
    case excellent = 5   // 优秀
    case masterwork = 6  // 杰作
    case legendary = 7   // 传世

    var englishName: String {
        switch self {
        case .awful: return "Awful"
        case .poor: return "Poor"
        case .normal: return "Normal"
        case .good: return "Good"
        case .excellent: return "Excellent"
        case .masterwork: return "Masterwork"
        case .legendary: return "Legendary"
        }
    }

    var chineseName: String {
        switch self {
        case .awful: return "劣质"
        case .poor: return "较差"
        case .normal: return "普通"
        case .good: return "良好"
        case .excellent: return "优秀"
        case .masterwork: return "杰作"
        case .legendary: return "传世"
        }
    }
}




/// 人种类型
enum SpeciesType: Int {
    
    /// 智人（标准人类）
    case human        = 1
    /// 尼安德特人（古人类，智力稍低，具有较大的体型）
    case neanderthal  = 2  // 尼安德特人
    /// 猪人（由猪类进化而来的生物，通常体型较大，具备较强的体力）
    case pigskin      = 3  // 猪人
    /// 胡萨人（以骑术为主的战士种族，拥有强大的战斗技能和耐力）
    case hussar       = 4  // 胡萨人
    /// 废人（曾是高级文明的成员，但因某种原因堕落，已失去大部分智慧）
    case waster       = 5  // 废人
    /// 恶魔人（恶魔的后裔，具有强大的魔法能力和恐怖的外貌）
    case impid        = 6  // 恶魔人
    /// 精灵（长寿且神秘的生物，通常具备高度的智力和灵敏的感官）
    case genie        = 7  // 精灵
    /// 冰熊人（生活在寒冷环境中的强大种族，具有冰雪魔法能力）
    case yttakin      = 8  // 冰熊人
    /// 嗜血者（由吸血鬼进化而来，饥渴的血腥生物，拥有强大的恢复力）
    case sanguophage  = 9  // 嗜血者
    /// 合成人（通过人工制造的生物，通常具有人类的外形，但体力和智能较为卓越）
    case android      = 10 // 合成人
    /// 虫族（外形像昆虫，拥有强大的群体作战能力）
    case insectoid    = 11 // 虫族
    /// 机械体（由机械构成的生物，拥有极高的耐久性和强大的战斗能力）
    case mechanoid    = 12 // 机械体

    
    var displayName: String {
        switch self {
        case .human:        return "Human"
        case .neanderthal:  return "Neanderthal"
        case .pigskin:      return "Pigskin"
        case .hussar:       return "Hussar"
        case .waster:       return "Waster"
        case .impid:        return "Impid"
        case .genie:        return "Genie"
        case .yttakin:      return "Yttakin"
        case .sanguophage:  return "Sanguophage"
        case .android:      return "Android"
        case .insectoid:    return "Insectoid"
        case .mechanoid:    return "Mechanoid"
        }
    }
}


enum CharacterTrait: Int {
    /// 乐观
    case optimist = 1
    /// 悲观
    case pessimist = 2
    /// 火焰癖
    case pyromaniac = 3
    /// 疾步如飞
    case nimble = 4
    /// 快速入睡
    case quickSleeper = 5
    /// 缓慢
    case slowpoke = 6
    /// 夜猫子
    case nightOwl = 7
    /// 艺术家
    case artistic = 8
    /// 冷血
    case coldBlooded = 9
    /// 好斗
    case triggerHappy = 10
    /// 拳击手
    case brawler = 11
    /// 吃货
    case gourmand = 12
    /// 精神病患者
    case psychopath = 13
    /// 贪婪
    case greedy = 14
    /// 勤劳
    case industrious = 15
    /// 化学兴趣
    case chemicalInterest = 16
    /// 精准射手
    case carefulShooter = 17
    /// 学习快
    case fastLearner = 18
    /// 善良
    case kind = 19
    /// 胆小
    case coward = 20
    /// 努力工作
    case hardWorker = 21
    /// 坚韧
    case tough = 22

    
    var traitDisplayName: String {
        switch self {
        case .optimist:        return "Optimist"
        case .pessimist:       return "Pessimist"
        case .pyromaniac:      return "Pyromaniac"
        case .nimble:          return "Nimble"
        case .quickSleeper:    return "Quick Sleeper"
        case .slowpoke:        return "Slowpoke"
        case .nightOwl:        return "Night Owl"
        case .artistic:        return "Artistic"
        case .coldBlooded:     return "Cold Blooded"
        case .triggerHappy:    return "Trigger Happy"
        case .brawler:         return "Brawler"
        case .gourmand:        return "Gourmand"
        case .psychopath:      return "Psychopath"
        case .greedy:          return "Greedy"
        case .industrious:     return "Industrious"
        case .chemicalInterest: return "Chemical Interest"
        case .carefulShooter:  return "Careful Shooter"
        case .fastLearner:     return "Fast Learner"
        case .kind:            return "Kind"
        case .coward:          return "Coward"
        case .hardWorker:      return "Hard Worker"
        case .tough:           return "Tough"
        }
    }
}



/// 执行顺序
enum WorkPriority: Int, Comparable, Codable {
    /// 不执行
    case none       = 0
    /// 最低
    case low        = 4
    /// 中低
    case medium     = 3
    /// 高
    case high       = 2
    /// 最高
    case highest    = 1
    
    static func < (lhs: WorkPriority, rhs: WorkPriority) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

/// 工作类型
enum WorkType: String, CaseIterable, Codable {
    
    /// 默认无
    case None
    /// 灭火
    case Firefighting
    /// 就医
    case SelfCare
    /// 医生
    case Doctor
    /// 休养
    case Rest
    /// 基本
    case Basic
    /// 监管
    case Supervise
    /// 驯兽
    case AnimalHandling
    /// 烹饪
    case Cooking
    /// 狩猎
    case Hunting
    /// 建造
    case Building
    /// 种植
    case Growing
    /// 采矿
    case Mining
    /// 割除
    case Cutting
    /// 锻造
    case Smithing
    /// 缝纫
    case Tailoring
    /// 艺术
    case Art
    /// 制作
    case Crafting
    /// 搬运
    case Hauling
    /// 清洁
    case Cleaning
    /// 研究
    case Research
}

/// 高优先级工作类型
enum HightWorkType: String, CaseIterable, Codable {
    
    /// 吃饭
    case Eat
    /// 睡觉
    case Sleep
    /// 休息
    case Relax
    
    /// 无
    case None
}


/// 人物技能
enum SkillType: String, CaseIterable {
    /// 射击
    case Shooting
    /// 格斗
    case Melee
    /// 建造
    case Construction
    /// 采矿
    case Mining
    /// 烹饪
    case Cooking
    /// 种植
    case Growing
    /// 驯兽
    case AnimalHandling
    /// 手工
    case Crafting
    /// 艺术
    case Art
    /// 医疗
    case Medicine
    /// 社交
    case Social
    /// 智识（研究能力）
    case Intellectual
    
    var skillDisplayName: String {
        switch self {
        case .Shooting: return "Shooting"
        case .Melee: return "Melee"
        case .Construction: return "Construction"
        case .Mining: return "Mining"
        case .Cooking: return "Cooking"
        case .Growing: return "Growing"
        case .AnimalHandling: return "Animal Handling"
        case .Crafting: return "Crafting"
        case .Art: return "Art"
        case .Medicine: return "Medicine"
        case .Social: return "Social"
        case .Intellectual: return "Intellectual"
        }
    }
}


/// 人物状态tab切换
enum Tab: String, CaseIterable {
    case log = "日志"
    case equipment = "装备"
    case social = "社交"
    case character = "角色"
    case needs = "需求"
    case health = "健康"
    case none = "空"
}



/// 角色之间的社交关系类型（参考 RimWorld）
enum RelationshipType: String {
    /// 陌生人（初次见面，或无交流历史）
    case stranger

    /// 结识（有过交流，但关系一般）
    case acquaintance

    /// 好友（有正向的互动关系，感情较好）
    case friend

    /// 密友（情感非常好，可能经常互动）
    case closeFriend

    /// 恋人（处于恋爱关系中）
    case lover

    /// 配偶（已结婚）
    case spouse

    /// 前任（曾经为恋人或配偶）
    case exLover

    /// 父母（亲代）
    case parent

    /// 子女（直系子女）
    case child

    /// 兄弟姐妹
    case sibling

    /// 亲属（表亲、堂亲等）
    case relative

    /// 领导（对方是自己团队的上级）
    case leader

    /// 下属（对方是自己的下属）
    case subordinate

    /// 仇敌（极度厌恶，对方曾造成重大伤害）
    case enemy

    /// 宿敌（持续的敌对关系）
    case rival

    /// 敬仰（对方是自己崇拜的对象）
    case admired

    /// 轻蔑（对方不被尊重，带有负面偏见）
    case despised
    
    /// 
    var relationshipDisplayName: String {
        switch self {
        case .stranger: return "Stranger"
        case .acquaintance: return "Acquaintance"
        case .friend: return "Friend"
        case .closeFriend: return "Close Friend"
        case .lover: return "Lover"
        case .spouse: return "Spouse"
        case .exLover: return "Ex-Lover"
        case .parent: return "Parent"
        case .child: return "Child"
        case .sibling: return "Sibling"
        case .relative: return "Relative"
        case .leader: return "Leader"
        case .subordinate: return "Subordinate"
        case .enemy: return "Enemy"
        case .rival: return "Rival"
        case .admired: return "Admired"
        case .despised: return "Despised"
        }
    }
}


/// 谈话的情感
enum InteractionEmotion: String, Codable {
    case neutral     // 平静
    case happy       // 开心
    case angry       // 愤怒
    case sad         // 伤心
    case surprised   // 惊讶
    case afraid      // 害怕
    case disgusted   // 厌恶
    case excited     // 兴奋
    case bored       // 无聊
    case proud       // 自豪
    case ashamed     // 羞愧
}


/// 人物概况
enum CapacityType: String, Codable, CaseIterable {
    /// 疼痛
    case pain
    /// 意识
    case consciousness
    /// 移动能力
    case moving
    /// 操作能力（手部功能）
    case manipulation
    /// 语言能力
    case talking
    /// 进食能力
    case eating
    /// 视觉能力
    case sight
    /// 听觉能力
    case hearing
    /// 呼吸能力
    case breathing
    /// 血液过滤（如肾功能）
    case bloodFiltration
    /// 血液循环（如心脏功能）
    case bloodPumping
    /// 消化能力
    case digestion
    
    var displayName: String {
           rawValue.prefix(1).capitalized + rawValue.dropFirst()
    }
}



enum BodyPartType: String, CaseIterable {

    // 头部区域
    /// 头部
    case head = "head"
    /// 颅骨
    case skull = "skull"
    /// 大脑
    case brain = "brain"
    /// 眼睛
    case eyes = "eyes"
    /// 耳朵
    case ears = "ears"
    /// 鼻子
    case nose = "nose"
    /// 下颌
    case jaw = "jaw"
    /// 舌头
    case tongue = "tongue"

    // 躯干区域
    /// 颈部
    case neck = "neck"
    /// 胸部
    case torso = "torso"
    /// 脊椎
    case spine = "spine"
    /// 心脏
    case heart = "heart"
    /// 肺
    case lungs = "lungs"
    /// 肝脏
    case liver = "liver"
    /// 肾脏
    case kidneys = "kidneys"
    /// 胃
    case stomach = "stomach"

    // 上肢区域
    /// 左臂
    case leftArm = "leftArm"
    /// 左手
    case leftHand = "leftHand"
    /// 左手指
    case leftFingers = "leftFingers"
    
    /// 右臂
    case rightArm = "rightArm"
    /// 右手
    case rightHand = "rightHand"
    /// 右手指
    case rightFingers = "rightFingers"

    // 下肢区域
    /// 左腿
    case leftLeg = "leftLeg"
    /// 左脚
    case leftFoot = "leftFoot"
    /// 左脚趾
    case leftToes = "leftToes"

    /// 右腿
    case rightLeg = "rightLeg"
    /// 右脚
    case rightFoot = "rightFoot"
    /// 右脚趾
    case rightToes = "rightToes"
    
    
    var displayName: String {
           rawValue.prefix(1).capitalized + rawValue.dropFirst()
    }
}



/// 医疗等级（决定治疗效果高低）
enum MedicalQuality: String {
    case herbal      // 草药
    case industrial  // 普通/工业级
    case glitter     // 高科技级
}


/// 游戏的主要模式状态
enum GameMode {
    case normal               // 默认模式：点击、移动等常规操作
    case build                // 建造模式：拖动放置建筑
    case storage              // 拉框选择存储区域
    case growing              // 拉框选择种植区域
    case deconstruct          // 拆除：拆除建造好的或者没建造的蓝图
}


/// 存储优先级
enum StoragePriority: Int, CaseIterable, Comparable {
    case low = 0
    case normal
    case preferred
    case important
    case critical
    
    var displayName: String {
        switch self {
        case .low: return "低"
        case .normal: return "普通"
        case .preferred: return "偏好"
        case .important: return "重要"
        case .critical: return "紧急"
        }
    }
    
    var englishName: String {
        switch self {
        case .low: return "Low"
        case .normal: return "Normal"
        case .preferred: return "Preferred"
        case .important: return "Important"
        case .critical: return "Critical"
        }
    }
    
    // 支持排序
    static func < (lhs: StoragePriority, rhs: StoragePriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}




enum MaterialType: Int {
    case wood = 1         // 木材
    case marble = 2       // 大理石
    case steel = 3        // 钢材（你可以按需添加）
    case stone = 4        // 石材
    case cloth = 5        // 布料
    
    
    case unowned = 10000
}

extension MaterialType: CustomStringConvertible {
    var description: String {
        switch self {
        case .wood: return "Wood"
        case .marble: return "Marble"
        case .steel: return "Steel"
        case .stone: return "Stone"
        case .cloth: return "Cloth"
        case .unowned: return "Unowned"
        }
    }
}

/// 蓝图类型枚举
enum BlueprintType: Int {
    case wall = 1            // 墙
    case airConditioner = 2  // 空调
    case table = 3           // 桌子
    case chair = 4           // 椅子
    case door = 5            // 门
    case bed = 6             // 床
    case cabinet = 7         // 柜子
    case floor = 8           // 地板
    case window = 9          // 窗户
    case roof = 10           // 屋顶

    /// 获取英文描述
    var description: String {
        switch self {
        case .wall: return "Wall"                     // 墙
        case .airConditioner: return "Air Conditioner" // 空调
        case .table: return "Table"                   // 桌子
        case .chair: return "Chair"                   // 椅子
        case .door: return "Door"                     // 门
        case .bed: return "Bed"                       // 床
        case .cabinet: return "Cabinet"               // 柜子
        case .floor: return "Floor"                   // 地板
        case .window: return "Window"                 // 窗户
        case .roof: return "Roof"                     // 屋顶
        }
    }
    
 
}



enum HaulTaskStage {
    /// 前往物品
    case movingToItem
    /// 正在搬运到目标位置
    case movingToTarget
}


enum RimWorldCrop: String, CaseIterable {
    // 粮食类
    case rice = "Rice"              // 稻米 - 生长快，产量适中，适合早期种植
    case potato = "Potato"          // 土豆 - 适合贫瘠土壤，生长稳定
    case corn = "Corn"              // 玉米 - 高产但生长周期长，适合后期批量种植
    case strawberry = "Strawberry"  // 草莓 - 可直接生吃，适合没有厨房的前期

    // 药用类
    case healroot = "Healroot"      // 愈伤草 - 可收获草药，用于治疗（需要种植技能8）

    // 纤维/工业类
    case cotton = "Cotton"          // 棉花 - 可产出布料，用于制作衣物和床铺等
    case devilstrand = "Devilstrand"// 恶魔皮菌丝 - 高耐久布料，生长极慢但很强（需要技能10）

    // 娱乐/奢侈品类
    case smokeleaf = "Smokeleaf"    // 烟叶 - 可制成烟草卷，缓解压力但会上瘾
    case psychoid = "Psychoid"      // 迷幻叶 - 用于制作迷幻茶或药物（如G茶、耀魂等）
    case hops = "Hops"              // 啤酒花 - 用于酿造啤酒，需配合啤酒桶
}




