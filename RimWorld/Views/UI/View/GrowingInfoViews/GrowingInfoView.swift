//
//  GrowingInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation
import UIKit

class GrowingInfoView: UIView {
    
    weak var entity:RMEntity?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        addSubview(bgView)
        bgView.addSubview(growingTableView)
        bgView.addSubview(removeBtn)
    }
    
    func setupLayout(){
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        removeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2.5)
            make.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        growingTableView.snp.makeConstraints { make in
            make.top.equalTo(removeBtn.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    @objc func deleteAction() {
        guard let entity = entity else {
            return
        }
        /// 删除实体
        RMEventBus.shared.requestRemoveEntity(entity)
        /// 点击空白
        RMEventBus.shared.requestClickEmpty()
    }
    
    
    func setData(_ entity:RMEntity) {
        self.entity = entity
        
        guard let growComponent = entity.getComponent(ofType: GrowInfoComponent.self) else {
            return
        }
        
        self.growingTableView.selectType = RimWorldCrop(rawValue: growComponent.cropType)!
        
        self.growingTableView.reloadData()
    }
    
    /// 改变种植种类
    func changeCropType(){
        guard let weakEntity = self.entity, let growComponent = weakEntity.getComponent(ofType: GrowInfoComponent.self) else {
            return
        }
        
        growComponent.cropType = self.growingTableView.selectType.rawValue
    }
    
    
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.BgColor()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        return view
    }()
    
    lazy var removeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("Delete"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var growingTableView = {
        let view = GrowingInfoTableView.init(frame: CGRectZero, style: .grouped)
        view.changeTypeBlock = {[weak self] in
            guard let self = self else {return}
            self.changeCropType()
        }
        return view
    }()
    
}


