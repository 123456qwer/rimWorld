//
//  WoodInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/7/1.
//

import Foundation
import UIKit

class WoodInfoView: UIView {
    
    /// 更新各种值
    weak var weakEntity:RMEntity?
    var nextBlock:( ()-> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(bgView)
        bgView.addSubview(name)
        bgView.addSubview(nextNodeBtn)
        setupLayout()
    }
    
    func setupLayout() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
   
      
        let leftPage = 12.0
//        let barHeight = 12.0
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
//            make.height.equalTo(labelHeight)
        }
       
        nextNodeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.height.equalTo(25.0)
        }
   
    }
    
    
    func setData(_ entity:RMEntity) {
        weakEntity = entity
        
        if let info = entity.getComponent(ofType: WoodBasicInfoComponent.self) {
            name.text = info.woodTexture
        }
    }
    
    
    

    
    @objc func nextAction(_ sender: UIButton) {
        nextBlock?()
    }
    
    
    /// 背景
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.BgColor()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        return view
    }()
    
    /// 名字
    lazy var name:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    
    /// 下一个node按钮
    lazy var nextNodeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nextNode"), for: .normal)
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
