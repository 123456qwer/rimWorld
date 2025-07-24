//
//  BodyPowerDetailView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 身体部位对人物能力的影响视图
class BodyPowerDetailView: UIView {
    
    let bgScroll:UIScrollView = UIScrollView()
    let contentView:UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        
        addSubview(bgScroll)
        bgScroll.addSubview(contentView)
        
        setupLayout()
        
    }
    
    private func setupLayout(){
        bgScroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(bgScroll.contentLayoutGuide)
            make.width.equalTo(bgScroll.frameLayoutGuide)
        }
    }
    
    
    func updateLayout(_ entity: RMEntity){
        let subViews = contentView.subviews
        for v in subViews {
            v.removeFromSuperview()
        }
        
        var yPage = 0.0
        
        let enums = CapacityType.allCases
        var index = 0
        for type in enums {
            
            let lineHeight = 15.0

            let bg = UIView()
            contentView.addSubview(bg)
            
            if index == enums.count - 1 {
                bg.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(yPage)
                    make.leading.equalToSuperview().offset(12.0)
                    make.trailing.equalToSuperview().offset(-12.0)
                    make.height.equalTo(lineHeight)
                    make.bottom.equalToSuperview()
                }
            }else {
                bg.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(yPage)
                    make.leading.equalToSuperview().offset(12.0)
                    make.trailing.equalToSuperview().offset(-12.0)
                    make.height.equalTo(lineHeight)
                }
            }
            
            /// 意识、移动能力等标题.
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 12.0)
            titleLabel.text = textAction(type.displayName)
            titleLabel.textColor = .white
            bg.addSubview(titleLabel)
            
            
            titleLabel.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
            }
            
            /// 设置身体状况，根据身体各个部件计算
            setContentLabel(entity, bg, type)
            
            index += 1
            yPage += lineHeight
        }
    }
    
    /// 设置身体状况，根据身体各个部件计算
    func setContentLabel(_ entity: RMEntity,
                         _ bg:UIView,
                         _ type:CapacityType){
        
        
        if let bodyPartComponent = entity.getComponent(ofType: BodyPartComponent.self) {
            
            /// 身体部件对应的能力值
            let capacityMap = bodyPartComponent.capacityInfluenceMap
           
          
            let capacityValues = capacityMap[type]!
            
            var value = 0
            
            for part in capacityValues {
                
                /// 身体结构类型
                let bodyType = part.part
                /// 占比
                let percent = part.weight
                /// 对应的身体部件的值
                let bodyPartValue = bodyPartComponent.getPartValue(key: bodyType.rawValue)
                
                value = value + Int(CGFloat(bodyPartValue) * CGFloat(percent))
                
            }

            var textColor = UIColor.green
            if value > 100 {
                textColor = UIColor.systemBlue
            }else if value < 100 {
                textColor = UIColor.gray
            }
            
            let contentBtn = UIButton(type: .custom)
            contentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            contentBtn.setTitle(textAction("\(value)%"), for: .normal)
            contentBtn.setTitleColor(textColor, for: .normal)
            bg.addSubview(contentBtn)
            
            contentBtn.snp.makeConstraints { make in
                make.top.trailing.bottom.equalToSuperview()
            }
            
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
