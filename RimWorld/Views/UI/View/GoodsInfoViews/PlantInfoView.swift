//
//  TreeInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/6/5.
//

import Foundation
import UIKit
import Combine

class PlantInfoView: UIView {
    
    var cancellables = Set<AnyCancellable>()

    /// 更新各种值
    weak var weakEntity:RMEntity?
    weak var ecsManager:ECSManager?
    var nextBlock:( ()-> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        RMInfoViewEventBus.shared.publisher().sink {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .updatePlant:
                self.updateTreeInfo()
            default:
                break
            }

        }.store(in: &cancellables)
    }
    
    func setupUI() {
        addSubview(bgView)
        bgView.addSubview(name)
        bgView.addSubview(chopBtn)
        bgView.addSubview(pickBtn)
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
        chopBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalTo(nextNodeBtn.snp.left).offset(-8)
            make.width.height.equalTo(33.0)
        }
        pickBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalTo(chopBtn.snp.left).offset(-8)
            make.width.height.equalTo(33.0)
        }

    }
    
    
    func setData(_ entity:RMEntity) {
        
        weakEntity = entity
        chopBtn.isSelected = EntityAbilityTool.ableToMarkCut(entity, ecsManager!)
        pickBtn.isSelected = EntityAbilityTool.ableToMarkPick(entity, ecsManager!)
    }
    
    func updateTreeInfo() {
        guard let entity = weakEntity else { return }
        setData(entity)
    }
    
    /// 点击割除
    @objc func chopAction(_ sender: UIButton) {
        
        guard let entity = weakEntity else { return }
        
        sender.isSelected = !sender.isSelected
        
        /// 
        RMEventBus.shared.requestCuttingTask(entity: entity,
                                             canChop: sender.isSelected)
    }
    
    /// 点击采摘
    @objc func pickAction(_ sender: UIButton) {
        guard let entity = weakEntity else { return }
        
        sender.isSelected = !sender.isSelected
        
        ///
        RMEventBus.shared.requestPickingTask(entity: entity, canPick: sender.isSelected)
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
    
    lazy var chopBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "axe"), for: .normal)
        btn.setImage(UIImage(named: "axeChop"), for: .selected)
        btn.backgroundColor = .black.withAlphaComponent(0.4)
        btn.layer.borderColor = UIColor.ml_color(hexValue: 0x007BFF).cgColor
        btn.layer.borderWidth = 1.5
        btn.addTarget(self, action: #selector(chopAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var pickBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "pickHand_stop"), for: .normal)
        btn.setImage(UIImage(named: "pickHand"), for: .selected)
        btn.backgroundColor = .black.withAlphaComponent(0.4)
        btn.layer.borderColor = UIColor.ml_color(hexValue: 0x007BFF).cgColor
        btn.layer.borderWidth = 1.5
        btn.addTarget(self, action: #selector(pickAction), for: .touchUpInside)
        return btn
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
