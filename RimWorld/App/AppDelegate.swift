//
//  AppDelegate.swift
//  RimWorld
//
//  Created by wu on 2025/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        measureTime {
            createData()
        }
        

        return true
    }
    
    func measureTime(_ block: () -> Void) {
        let start = CFAbsoluteTimeGetCurrent()
        block()
        let end = CFAbsoluteTimeGetCurrent()
        ECSLogger.log("耗时：\(end - start) 秒")
    }
    
    /// 初始化游戏数据
    func createData() {
        
        if UserDefaults.standard.bool(forKey: "isLoadData") { return }
        
        UserDefaults.standard.set(true, forKey: "isLoadData")
        
        createMap()
        
//        let qiaodan = EntityFactory.shared.createCharacterEntity(kMichaelJordan)
        let yuefei = EntityFactory.shared.createCharacterEntity(kYueFei)

//        let so = SocialComponent()
//        so.relationship[yuefei.entityID] = RelationshipType.friend.rawValue
//        so.entityID = qiaodan.entityID
//        qiaodan.addComponent(so)

//        let so2 = SocialComponent()
//        so2.relationship[qiaodan.entityID] = RelationshipType.friend.rawValue
//        so2.entityID = yuefei.entityID
//        yuefei.addComponent(so2)

//        EntityFactory.shared.saveEntity(entity: qiaodan)
        EntityFactory.shared.saveEntity(entity: yuefei)
//
        let eventLog = DBManager.shared.getEventLog()
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "谈到印度战机问题",emotion: .surprised)
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "开玩笑的说到我是历史第一人",emotion: .happy)
//        eventLog.addLog(from: yuefei.entityID, to: qiaodan.entityID, content: "谈到威名远扬",emotion: .happy)
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "嘲笑猩猩",emotion: .neutral)
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "谈到抽雪茄",emotion: .neutral)
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "谈到篮球运动",emotion: .excited)
//        eventLog.addLog(from: qiaodan.entityID, to: yuefei.entityID, content: "谈到肤色和人种",emotion: .sad)
//        DBManager.shared.updateEventLog(eventLog)
    }
    
    
    /// 初始化地图数据
    func createMap(){
        
        let tileSize = 32.0
        
        var treeCount = 0
        for y in -60...60 {
            for x in -80...80 {
                
                /// 地板
                let pointX = CGFloat(x) * tileSize
                let pointY = CGFloat(y) * tileSize
//                let node = SKSpriteNode(color: .black, size: CGSize(width: tileSize, height: tileSize))
//                node.position = CGPoint(x: pointX, y: pointY)
//                let textureName = ["城堡地面1","城堡地面4","城堡地面5","城堡地面7"].randomElement()
//                node.texture = TextureManager.shared.getTexture(textureName!)
//                self.addChild(node)
                
                /// 树
                if Int.random(in: 0...100) < 2 {
                    EntityFactory.shared.tree(point: CGPoint(x: pointX, y: pointY))
                }
                
            }
        }
    }
  

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        RMEventBus.shared.requestTerminateForRemoveTaskOwner()
    }
}

