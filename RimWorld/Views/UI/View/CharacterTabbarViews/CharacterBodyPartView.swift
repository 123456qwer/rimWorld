//
//  CharacterBodyPartView.swift
//  RimWorld
//
//  Created by wu on 2025/5/14.
//

import Foundation
import UIKit

/// 健康，身体状况
class CharacterBodyPartView: UIView {
    
    let bg:UIView = UIView()
    
    let left:UIView = UIView()
    /// 概况
    let overviewBtn:UIButton = UIButton(type: .custom)
    /// 手术
    let surgeryBtn:UIButton = UIButton(type: .custom)
    /// 食物限制
    let foodLabel:UILabel = UILabel()
    let foodBtn:UIButton = UIButton(type: .custom)
    /// 医药限制
    let medicineLabel:UILabel = UILabel()
    let medicineBtn:UIButton = UIButton(type: .custom)
    
    /// 分割线
    let leftLine:UIView = UIView()
    
    /// 能力值
    let powerView:BodyPowerDetailView = BodyPowerDetailView()
    
    
    /// 具体身体部位
    let bodyPartView:BodyPartDetailView = BodyPartDetailView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        bg.backgroundColor = UIColor.BgColor()
        
        addSubview(bg)
        addSubview(left)
        addSubview(bodyPartView)

        
        setupLeftUI()
        setupLayout()
    }
    
    private func setupLeftUI(){
        
        overviewBtn.setTitle(textAction("Overview"), for: .normal)
        overviewBtn.setTitleColor(.white, for: .normal)
        overviewBtn.setTitleColor(.green, for: .selected)
        overviewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        overviewBtn.layer.borderWidth = 2.0
        overviewBtn.layer.borderColor = UIColor.white.cgColor
        
        surgeryBtn.setTitle(textAction("Surgery"), for: .normal)
        surgeryBtn.setTitleColor(.white, for: .normal)
        surgeryBtn.setTitleColor(.green, for: .selected)
        surgeryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        surgeryBtn.layer.borderWidth = 2.0
        surgeryBtn.layer.borderColor = UIColor.white.cgColor
        
       
        foodLabel.textColor = .white
        foodLabel.numberOfLines = 0
        foodLabel.text = textAction("Food Restriction:")
        foodLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        foodBtn.setTitleColor(.white, for: .normal)
        foodBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        foodBtn.setTitle(textAction("无限制"), for: .normal)
        foodBtn.layer.borderColor = UIColor.white.cgColor
        foodBtn.layer.borderWidth = 1.0
        
        
        medicineLabel.textColor = .white
        medicineLabel.numberOfLines = 0
        medicineLabel.text = textAction("Medicine Restriction:")
        medicineLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        medicineBtn.setTitleColor(.white, for: .normal)
        medicineBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        medicineBtn.setTitle(textAction("无限制"), for: .normal)
        medicineBtn.layer.borderColor = UIColor.white.cgColor
        medicineBtn.layer.borderWidth = 1.0
        
        leftLine.backgroundColor = .white
        
        overviewBtn.isSelected = true
        
        left.layer.borderColor = UIColor.white.cgColor
        left.layer.borderWidth = 1.5
        
        left.ml_addSubviews([overviewBtn,surgeryBtn,foodLabel,foodBtn,medicineLabel,medicineBtn,leftLine,powerView])
     
        
        setupLeftLayout()
    }
    
    private func setupLeftLayout(){
        let btnHeight = 20.0
        let labelHeight = 30.0
        overviewBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/2.0).offset(-1.0)
            make.height.equalTo(btnHeight)
        }
        surgeryBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/2.0).offset(-1.0)
            make.height.equalTo(btnHeight)
        }
        foodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4.0)
            make.top.equalTo(overviewBtn.snp.bottom).offset(4.0)
            make.height.equalTo(labelHeight)
            make.width.equalTo(overviewBtn.snp.width)
        }
        let footBtnWidth = foodBtn.intrinsicContentSize.width + 12.0
        foodBtn.snp.makeConstraints { make in
            make.centerX.equalTo(surgeryBtn.snp.centerX)
            make.centerY.equalTo(foodLabel.snp.centerY)
            make.width.equalTo(footBtnWidth)
        }
        medicineLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4.0)
            make.top.equalTo(foodLabel.snp.bottom)
            make.height.equalTo(labelHeight)
            make.width.equalTo(overviewBtn.snp.width)
        }
        let medicineBtnWidth = medicineBtn.intrinsicContentSize.width + 12.0
        medicineBtn.snp.makeConstraints { make in
            make.centerX.equalTo(surgeryBtn.snp.centerX)
            make.centerY.equalTo(medicineLabel.snp.centerY)
            make.width.equalTo(medicineBtnWidth)
        }
        leftLine.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12.0)
            make.trailing.equalToSuperview().offset(-12.0)
            make.height.equalTo(1.0)
            make.top.equalTo(medicineBtn.snp.bottom).offset(12.0)
        }
        powerView.snp.makeConstraints { make in
            make.top.equalTo(leftLine.snp.bottom).offset(12.0)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12.0)
        }
        
//        powerView.backgroundColor = .orange
    }
    
    private func setupLayout() {
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        left.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        bodyPartView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(2/3.0)
        }
    }
    
    
    func updateLayout(_ entity: RMEntity) {
        powerView.updateLayout(entity)
        bodyPartView.updateLayout(entity)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
