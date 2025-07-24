//
//  CharacterLogView.swift
//  RimWorld
//
//  Created by wu on 2025/5/28.
//

import UIKit

class CharacterLogView: UIView {

    let bg:UIView = UIView()
    let topView:UIView = UIView()
    let logView:LogView = LogView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    private func setupUI() {
        addSubview(bg)
        bg.addSubview(topView)
        bg.addSubview(logView)
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        bg.backgroundColor = UIColor.BgColor()
        
//        topView.backgroundColor = .orange
        
        setupLayout()
    }

    private func setupLayout() {
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(40)
        }
        logView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func updateLayout(_ entity: RMEntity) {
        logView.updateLayout(entity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
