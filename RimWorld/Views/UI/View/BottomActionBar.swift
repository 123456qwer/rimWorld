//
//  BottomActionBar.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit
import Combine

class BottomActionBar: UIView {
    
    var cancellables = Set<AnyCancellable>()
    var isSelect:Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        
        RMInfoViewEventBus.shared.publisher().sink {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .clickMainInfo(let type):
                self.updateBottomBtn(actionType: type)
            default:
                break
            }

        }.store(in: &cancellables)
    }
    
    /// 刷新底部按钮颜色
    func updateBottomBtn(actionType: ActionType){
        
        isSelect = true
        planBtn.setTitleColor(.red, for: .normal)
        
        planBtn.setTitle(textAction(actionType.rawValue), for: .normal)
        
        switch actionType {
        case .none:
            planBtn.setTitle(textAction("Plan"), for: .normal)
            planBtn.setTitleColor(.black, for: .normal)
            isSelect = false
        default:
            break
        }
    }
    
    
    func setupUI() {
        addSubview(planBtn)
        addSubview(workBtn)
    }
    
    
    func setupLayout() {
      
        planBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(60.0)
        }
        workBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(planBtn.snp.right)
            make.bottom.equalToSuperview()
            make.width.equalTo(60.0)
        }
 
       
    }
    
    
 
    
    lazy var planBtn:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Plan"))
        return btn
    }()
    
    lazy var workBtn:UIButton = {
        let btn = UIButton(type: .custom)
        styleButton(sender: btn, text: textAction("Work"))
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
