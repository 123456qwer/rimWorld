//
//  MoodDetailView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 具体的心情描述，支持增减变化，如 （心无杂念，奢华享受，身上非常疼等等）
/// 需要实时更新的心情状态
class MoodDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
