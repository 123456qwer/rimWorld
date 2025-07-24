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
    
    
    /// 树进度条
    func treeBarAnimation(total: Double, current: Double) {
        if progressBar.parent == nil {
            addChild(progressBar)
        }
        progressBar.isHidden = false
        progressBar.updateProgress(current: current, total: total)
    }
    
    
    /// 树被砍断动画
    func treeCutAnimation() {
        self.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.3),SKAction.removeFromParent()]))
    }
}


