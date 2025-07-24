//
//  RenderContext.swift
//  RimWorld
//
//  Created by wu on 2025/5/9.
//

import Foundation

protocol RenderContext {
    
    /// 根据是否有父ID来确认是直接添加到场景还是添加到某一Node上
    func addNode(_ node: RMBaseNode, to parentID: Int)
    /// 根据实体ID获取Node
    func getNode(for entityID: Int) -> RMBaseNode?
    
}
