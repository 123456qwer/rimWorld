//
//  RMBaseNode.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import SpriteKit

class RMBaseNode:SKSpriteNode {
    
    weak var rmEntity:RMEntity?
    
    var defaultXscale:CGFloat = 1
    var defaultYscale:CGFloat = 1
    
    
    /// 进度条
    lazy var progressBar: RMProgressBarNode = {
        let bar = RMProgressBarNode()
        bar.position = CGPoint(x: -self.size.width / 2.0 , y: 35)
        bar.zPosition = 10
        return bar
    }()

    
    /// 睡觉动画的Z
    lazy var zLabel:SKLabelNode = {
        let label = SKLabelNode(text: "Z")
        label.fontName = "Arial"
        label.fontSize = 40
        label.alpha = 1.0
        label.color = .white
        label.zPosition = 100
        return label
    }()

}


/// 通用
extension RMBaseNode {
    
    /// 进度条
    func barAnimation(total: Double, current: Double) {
        if progressBar.parent == nil {
            addChild(progressBar)
        }
        progressBar.isHidden = false
        progressBar.updateProgress(current: current, total: total)
    }
}


/// 砍树相关
extension RMBaseNode {
    
    /// 砍树动画
    func cuttingAnimation() {
        
        let cutting = self.childNode(withName: "cutting") ?? SKSpriteNode(texture: TextureManager.shared.getTexture("cutting"), size: CGSize(width: 80, height: 80))
        cutting.name = "cutting"
        cutting.position = CGPoint(x: 0, y: -20)
        cutting.zPosition = 12
        if cutting.parent == nil {
            self.addChild(cutting)
        }
        
        let animation = cutting.action(forKey: "cutting")
        if animation == nil {
            let animation = AnimationUtils.rotateActionRep(withDegreesArr: [10,-10], timeArr: [0.6,0.6])
            cutting.run(animation,withKey: "cutting")
        }
    }
    
    /// 停止砍树
    func stopCuttingAnimation() {
        let cutting = self.childNode(withName: "cutting")
        cutting?.removeFromParent()
        self.progressBar.isHidden = true
    }
   
}



/// 建造相关
extension RMBaseNode {
    
    /// 建造动画
    func buildingAnimation(){
        
        let cutting = self.childNode(withName: "building") ?? SKSpriteNode(texture: TextureManager.shared.getTexture("building"), size: CGSize(width: 40, height: 40))
        cutting.name = "building"
        cutting.position = CGPoint(x: 0, y: 0)
        cutting.zPosition = 12
        cutting.zRotation = MathUtils.degreesToRadians(-20)
        if cutting.parent == nil {
            self.addChild(cutting)
        }
        
        let animation = cutting.action(forKey: "building")
        if animation == nil {
            let animation = AnimationUtils.rotateActionRep(withDegreesArr: [10,-10], timeArr: [0.6,0.6])
            cutting.run(animation,withKey: "building")
        }
    }
    
    /// 停止建造
    func stopBuildingAnimation() {
        let cutting = self.childNode(withName: "building")
        cutting?.removeFromParent()
        self.progressBar.isHidden = true
    }
    
    
    /// 建造完成（这里需要根据建造类型生成对应对象）
    func buildFinishAnimation(_ blueprintEntity: RMEntity) {
        
        stopBuildingAnimation()
        
  
    }
    
    
   
}
