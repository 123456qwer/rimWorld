//
//  RelationshipView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 人物关系图
class RelationshipView: UIView {
    
    let bgScroll: UIScrollView = UIScrollView()
    let contentView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI(){
        addSubview(bgScroll)
        bgScroll.addSubview(contentView)
        bgScroll.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-24.0)
            make.trailing.leading.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(bgScroll.contentLayoutGuide)
            make.width.equalTo(bgScroll.frameLayoutGuide)
        }
    }
    
  
    

    /// 修改关系图
    func updateLayout(_ entity: RMEntity){
        
        let sub = contentView.subviews
        for view in sub {
            view.removeFromSuperview()
        }
        
        if let socialComponent = entity.getComponent(ofType: SocialComponent.self) {
            
            var yPage = 0.0
            let lineHeight = 16.0
            let leftPage = 12.0
            
            for (key,value) in socialComponent.relationship {
                
                let relationEntity = DBManager.shared.getEntity(key)
                
                let bg = UIView()
//                bg.backgroundColor = UIColor.randomColor()
                contentView.addSubview(bg)
                
                bg.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(yPage)
                    make.height.equalTo(lineHeight)
                    make.leading.equalToSuperview().offset(leftPage)
                    make.trailing.equalToSuperview().offset(-leftPage)
                }
                
                let relationship = RelationshipType(rawValue: value)
                let relationshipText = relationship?.relationshipDisplayName ?? ""
                
                let titleLabel = UILabel()
                titleLabel.font = UIFont.systemFont(ofSize: 12.0)
                titleLabel.textColor = .white
                titleLabel.text = textAction(relationshipText)
                bg.addSubview(titleLabel)
                

                titleLabel.snp.makeConstraints { make in
                    make.top.bottom.leading.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(1/3.0)
                }
                
                let nameLabel = UILabel()
                nameLabel.font = UIFont.systemFont(ofSize: 12.0)
                nameLabel.textColor = .white
                bg.addSubview(nameLabel)
                
                nameLabel.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(1/3.0)
                }
                
                if let basicComponent = relationEntity.getComponent(ofType: BasicInfoComponent.self){
                    nameLabel.text = "\(basicComponent.nickName),\(basicComponent.firstName)\(basicComponent.lastName)"
                }
                
                let scoreLabel = UILabel()
                scoreLabel.font = UIFont.systemFont(ofSize: 12.0)
                bg.addSubview(scoreLabel)
                
                /// 关系评分
                let score = socialComponent.getScore(relationship ?? RelationshipType.stranger)
                if score > 0 {
                    scoreLabel.text = "+\(score)"
                    scoreLabel.textColor = .green
                }else if score < 0 {
                    scoreLabel.text = "\(score)"
                    scoreLabel.textColor = .red
                }else {
                    scoreLabel.text = "-"
                    scoreLabel.textColor = .white
                }
                
                scoreLabel.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(1/3.0)
                }
                
                yPage += lineHeight
            }
            
        }
        
    }
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
