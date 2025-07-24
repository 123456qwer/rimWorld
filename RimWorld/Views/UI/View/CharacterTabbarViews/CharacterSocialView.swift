//
//  CharacterSocialView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 社交基础图
class CharacterSocialView: UIView {
    
    let bg:UIView = UIView()
    
    /// 分配职位按钮
    let roleView:UIView = UIView()
    /// 恋爱按钮
    let loveBtn:UIButton = UIButton(type: .custom)
    /// 分配职位按钮
    let roleBtn:UIButton = UIButton(type: .custom)
    /// 已经设置的职位
    let setRoleBtn:UIButton = UIButton(type: .custom)
    
    /// 中间人物关系
    let relationshipView:RelationshipView = RelationshipView()
    /// 底部人物聊天详情
    let talkView:TalkView = TalkView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    private func setupUI() {
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        bg.backgroundColor = UIColor.BgColor()
        
        loveBtn.layer.borderColor = UIColor.white.cgColor
        loveBtn.layer.borderWidth = 1.0
        loveBtn.backgroundColor = UIColor.btnBgColor()
        loveBtn.setTitle(textAction("Love.."), for: .normal)
        loveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        
        roleBtn.layer.borderColor = UIColor.white.cgColor
        roleBtn.layer.borderWidth = 1.0
        roleBtn.backgroundColor = UIColor.btnBgColor()
        roleBtn.setTitle(textAction("Assign"), for: .normal)
        roleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        
//        setRoleBtn.layer.borderColor = UIColor.white.cgColor
//        setRoleBtn.layer.borderWidth = 1.0
        setRoleBtn.backgroundColor = UIColor.btnBgColor()
        setRoleBtn.setTitle(textAction("Unassigned"), for: .normal)
        setRoleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        
        
//        roleView.backgroundColor = .orange
//        relationshipView.backgroundColor = .cyan
//        talkView.backgroundColor = .blue
        
        addSubview(bg)
       
        bg.ml_addSubviews([roleView,relationshipView,talkView])
        roleView.ml_addSubviews([loveBtn,roleBtn,setRoleBtn])
        
        let topLine = UIView()
        topLine.backgroundColor = .white
        roleView.addSubview(topLine)
        
        topLine.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo(2.0)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .white
        relationshipView.addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo(2.0)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        roleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30.0)
        }
        relationshipView.snp.makeConstraints { make in
            make.top.equalTo(roleView.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        talkView.snp.makeConstraints { make in
            make.top.equalTo(relationshipView.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
        }
        let btnWidth = loveBtn.intrinsicContentSize.width + 12.0
        loveBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.bottom.equalToSuperview().offset(-5.0)
            make.width.equalTo(btnWidth)
        }
        let btnWidth2 = roleBtn.intrinsicContentSize.width + 12.0
        roleBtn.snp.makeConstraints { make in
            make.right.equalTo(loveBtn.snp.left).offset(-12.0)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
            make.bottom.equalToSuperview().offset(-5.0)
            make.width.equalTo(btnWidth2)
        }
        
    }
    
    
    func updateSocialLayout(_ entity: RMEntity) {
        
        relationshipView.updateLayout(entity)
        talkView.updateLayout(entity)
        
        /// 当前人物职位
        if let basicComponent = entity.getComponent(ofType: BasicInfoComponent.self) {
            setRoleBtn.setTitle(basicComponent.roleTitle, for: .normal)
            let btnWidth2 = setRoleBtn.intrinsicContentSize.width + 12.0
            setRoleBtn.snp.removeConstraints()
            setRoleBtn.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(12.0)
                make.centerY.equalToSuperview()
                make.top.equalToSuperview().offset(5.0)
                make.bottom.equalToSuperview().offset(-5.0)
                make.width.equalTo(btnWidth2)
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
