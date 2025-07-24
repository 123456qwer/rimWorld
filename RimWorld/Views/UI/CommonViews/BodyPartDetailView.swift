//
//  BodyPartDetailView.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//
import Foundation
import UIKit

/// 具体身体部位零件
class BodyPartDetailView: UIView {
    
    let bgScroll:UIScrollView = UIScrollView()
    let contentView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    func updateLayout(_ entity: RMEntity) {
        let views = contentView.subviews
        for v in views { v.removeFromSuperview() }
        
        if let bodyPartComponent = entity.getComponent(ofType: BodyPartComponent.self) {
            /// 身体部件
            let allBodys = BodyPartType.allCases
            var yPage = 20.0
            var index = 0
            var valueIndex = 0
            let barHeight = 20.0
            for part in allBodys{
                
                let bodyValue = bodyPartComponent.getPartValue(key: part.rawValue)
                
                /// 不等于0，才需要描述语
                if bodyValue != 100 {
                    
                    let bg = UIView()
                    bg.backgroundColor = valueIndex % 2 == 0 ? UIColor.btnBgColor() : UIColor.clear
                    contentView.addSubview(bg)
                    
                    if index == allBodys.count - 1 {
                        bg.snp.makeConstraints { make in
                            make.top.equalToSuperview().offset(yPage)
                            make.leading.equalToSuperview().offset(12.0)
                            make.trailing.equalToSuperview().offset(-12.0)
                            make.height.equalTo(barHeight)
                            make.bottom.equalToSuperview()
                        }
                    }else{
                        bg.snp.makeConstraints { make in
                            make.top.equalToSuperview().offset(yPage)
                            make.leading.equalToSuperview().offset(12.0)
                            make.trailing.equalToSuperview().offset(-12.0)
                            make.height.equalTo(barHeight)
                        }
                    }
                    
                    /// 值越少说明状况越危险，为0说明缺失，超过100说明额外效果，比如仿生臂
                    var textColor = UIColor.systemBlue
                    
                    if bodyValue < 100 && bodyValue >= 75 {
                        textColor = UIColor.ml_color(hexValue: 0xD8BC6F)
                    }else if bodyValue < 75 && bodyValue >= 50 {
                        textColor = UIColor.ml_color(hexValue: 0xD45E32)
                    }else if bodyValue < 50 && bodyValue >= 1 {
                        textColor = .red
                    }else if bodyValue == 0{
                        textColor = .gray
                    }
                    
                    let label = UILabel()
                    label.textColor = textColor
                    label.font = UIFont.systemFont(ofSize: 13.0)
                    label.text = textAction(part.displayName)
                    bg.addSubview(label)
                    
                    label.snp.makeConstraints { make in
                        make.top.leading.bottom.equalToSuperview()
                    }
                    
                    yPage = yPage + barHeight
                    valueIndex += 1
                }
                
                index += 1
            }
            
        }
        
    }
    
    private func setupUI() {
        
        addSubview(bgScroll)
        bgScroll.addSubview(contentView)
        setupLayout()
        
//        bgScroll.backgroundColor = .orange
//        contentView.backgroundColor = .cyan
    }
    
    private func setupLayout() {
        bgScroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(bgScroll.contentLayoutGuide)
            make.width.equalTo(bgScroll.frameLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

