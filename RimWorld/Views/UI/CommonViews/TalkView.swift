//
//  TalkView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 人物聊天图
class TalkView: UIView {
    
    let talkTableView:TalkTableView = TalkTableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    private func setupUI() {
        addSubview(talkTableView)
        setupLayout()
    }
    
    private func setupLayout() {
        talkTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// 更新聊天会话
    func updateLayout(_ entity: RMEntity) {
        talkTableView.reloadLog(entity)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
