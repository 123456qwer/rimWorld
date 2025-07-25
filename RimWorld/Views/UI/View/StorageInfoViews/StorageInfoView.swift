//
//  SaveAreaInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import Foundation
import UIKit

class StorageInfoView: UIView {
    
    weak var entity:RMEntity?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        saveTableView.reloadBlock = {[weak self] in
            guard let self = self else {return}
            RMEventBus.shared.requestChangeSaveAreaEntity(entity: self.entity ?? RMEntity())
        }
    }
    
    
    func setData(_ entity: RMEntity) {
        saveTableView.setData(entity)
        self.entity = entity
    }
    
    @objc func cancelAllAction() {
        saveTableView.cancelAllAction()
    }
    
    @objc func allowAllAction() {
        saveTableView.allowAllAction()
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
    
    func setupUI() {
        addSubview(bgView)
        bgView.addSubview(priorityButton)
        bgView.addSubview(renameButton)
        bgView.addSubview(deleteButton)
        bgView.addSubview(cancelAllButton)
        bgView.addSubview(allowAllButton)
        bgView.addSubview(saveTableView)
        setupLayout()
    }
    
    func setupLayout() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.layoutIfNeeded()
        
        let page = 12.0

        let width = (UIScreen.screenWidth / 3.0 - page * 4.0) / 3.0
        priorityButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(page)
            make.width.equalTo(width)
            make.height.equalTo(30)
        }
        
        renameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(priorityButton.snp.right).offset(page)
            make.width.equalTo(width)
            make.height.equalTo(30.0)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-page)
            make.width.equalTo(width)
            make.height.equalTo(30.0)
        }
        
        cancelAllButton.snp.makeConstraints { make in
            make.top.equalTo(priorityButton.snp.bottom).offset(5.0)
            make.leading.equalToSuperview().offset(page)
            make.width.equalToSuperview().multipliedBy(1 / 2.0).offset(-15.0)
            make.height.equalTo(30.0)
        }
        allowAllButton.snp.makeConstraints { make in
            make.top.equalTo(priorityButton.snp.bottom).offset(5.0)
            make.trailing.equalToSuperview().offset(-page)
            make.width.equalToSuperview().multipliedBy(1 / 2.0).offset(-15.0)
            make.height.equalTo(30.0)
        }
        saveTableView.snp.makeConstraints { make in
            make.top.equalTo(allowAllButton.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.BgColor()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        return view
    }()
    
    lazy var priorityButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("优先级：普通"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return btn
    }()
    
    lazy var renameButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("Rename"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return btn
    }()
    
    lazy var deleteButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("Delete"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelAllButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("Cancel All"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(cancelAllAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var allowAllButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(textAction("Allow All"), for: .normal)
        btn.backgroundColor = UIColor.btnBgColor()
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(allowAllAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveTableView = {
        let view = StorageInfoTabelView.init(frame: CGRectZero, style: .grouped)
        return view
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
