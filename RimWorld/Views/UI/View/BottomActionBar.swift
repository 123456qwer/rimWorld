//
//  BottomActionBar.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit

class BottomActionBar: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    func clickPlan (){
        
        planBtn.isSelected = !planBtn.isSelected
        
        if planBtn.isSelected {
            planBtn.backgroundColor = .red
        }else{
            planBtn.backgroundColor = .white
        }
        
        planBtnBuild.isHidden = !planBtn.isSelected
        planBtnSaveArea.isHidden = !planBtn.isSelected
        plantBtnRemove.isHidden = !planBtn.isSelected
        planBtnGrowing.isHidden = !planBtn.isSelected
    }
    
    
    func hiddenSubButton() {
        planBtnBuild.isHidden = true
        planBtnSaveArea.isHidden = true
        plantBtnRemove.isHidden = true
        planBtnGrowing.isHidden = true
    }
    
    func setupUI() {
        addSubview(workBtn)
        addSubview(planBtn)
        addSubview(planBtnSaveArea)
        addSubview(planBtnBuild)
        addSubview(plantBtnRemove)
        addSubview(planBtnGrowing)
    }
    
    func setupLayout() {
        workBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(60.0)
        }
        planBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(workBtn.snp.right)
            make.bottom.equalToSuperview()
            make.width.equalTo(60.0)
        }
        planBtnSaveArea.snp.makeConstraints { make in
            make.left.equalTo(workBtn.snp.right)
            make.width.equalTo(60.0)
            make.bottom.equalTo(planBtn.snp.top).offset(-5)
            make.height.equalTo(planBtn.snp.height)
        }
        planBtnGrowing.snp.makeConstraints { make in
            make.left.equalTo(workBtn.snp.right)
            make.width.equalTo(60.0)
            make.bottom.equalTo(planBtnSaveArea.snp.top).offset(-5)
            make.height.equalTo(planBtn.snp.height)
        }
        planBtnBuild.snp.makeConstraints { make in
            make.left.equalTo(workBtn.snp.right)
            make.width.equalTo(60.0)
            make.bottom.equalTo(planBtnGrowing.snp.top).offset(-5)
            make.height.equalTo(planBtn.snp.height)
        }
        plantBtnRemove.snp.makeConstraints { make in
            make.left.equalTo(workBtn.snp.right)
            make.width.equalTo(60.0)
            make.bottom.equalTo(planBtnBuild.snp.top).offset(-5)
            make.height.equalTo(planBtn.snp.height)
        }
        
        planBtnSaveArea.isHidden = true
        planBtnBuild.isHidden = true
        plantBtnRemove.isHidden = true
        planBtnGrowing.isHidden = true
    }
    
    
    lazy var workBtn:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Work"))
        return btn
    }()
    
    lazy var planBtn:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Plan"))
        return btn
    }()
    
    lazy var planBtnBuild:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Build"))
        return btn
    }()
    
    lazy var plantBtnRemove:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Deconstruct"))
        return btn
    }()
    
    lazy var planBtnSaveArea:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Storage"))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return btn
    }()
    
    lazy var planBtnGrowing:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("PlantZone"))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return btn
    }()
    
    
    
    private func styleButton(sender:UIButton, text:String){
        sender.backgroundColor = .white
        sender.layer.masksToBounds = true
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 2.0
        sender.layer.cornerRadius = 4.0
        sender.setTitle(text, for: .normal)
        sender.setTitleColor(.black, for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 把坐标转换给子视图
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(convertedPoint, with: event) {
                return result
            }
        }
        return super.hitTest(point, with: event)
    }
}
