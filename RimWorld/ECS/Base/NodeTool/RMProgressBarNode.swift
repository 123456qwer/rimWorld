//
//  RMProgressBarNode.swift
//  RimWorld
//
//  Created by wu on 2025/6/9.
//

import Foundation
import SpriteKit

class RMProgressBarNode: SKNode {
    
    private let backgroundBar: SKSpriteNode
    private let fillBar: SKSpriteNode
    
    private let barWidth: CGFloat = 60
    private let barHeight: CGFloat = 10
    
    override init() {
        backgroundBar = SKSpriteNode(color: .black, size: CGSize(width: barWidth, height: barHeight))
        backgroundBar.anchorPoint = CGPoint(x: 0, y: 0.5)

        fillBar = SKSpriteNode(color: .yellow, size: CGSize(width: 0.1, height: barHeight))
        fillBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        fillBar.position = .zero

        super.init()
        
        addChild(backgroundBar)
        backgroundBar.addChild(fillBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(current: Double, total: Double) {
        guard total > 0 else { return }
        let progress = current / total
        fillBar.size.width = barWidth * progress
    }
}

