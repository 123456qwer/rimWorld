//
//  LogView.swift
//  RimWorld
//
//  Created by wu on 2025/5/28.
//


import UIKit

/// 人物所有事件图
class LogView: UIView {
    
    let bgScroll: UIScrollView = UIScrollView()
    let contentView:UIView = UIView()
    let logTableView:LogTableView = LogTableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    private func setupUI() {
        addSubview(logTableView)
        setupLayout()
    }
    
    private func setupLayout() {
        logTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// 更新聊天会话
    func updateLayout(_ entity: RMEntity) {
        logTableView.reloadLog(entity)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
