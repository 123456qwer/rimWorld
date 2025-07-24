//
//  CharacterStatusView1.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import UIKit
import Combine

/// 角色基础描述，带健康、心情、能量、活动区域的那个view
class CharacterInfoView: UIView {
    
    var cancellables = Set<AnyCancellable>()

    
    /// 更新各种值
    weak var weakEntity:RMEntity?
    var nextBlock:( ()-> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEnergy), name: .RMGameTimeUpdateEnergy, object: nil)
        
        RMInfoViewEventBus.shared.publisher().sink {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .updateCharacter:
                self.updateCharacterState()
            default:
                break
            }
        }.store(in: &cancellables)
        
        setupUI()
    }
    
    @objc func updateCharacterState() {
        guard let entity = weakEntity else { return }
        
        ///当前行为
        if let actionCom = entity.getComponent(ofType: ActionStateComponent.self) {
            activeJobInfo.text = textAction(actionCom.getActionType())
        }
    }
    
    /// 休息值
    @objc func updateEnergy() {
        
        guard let entity = weakEntity else { return }
        /// 休息值
        var currentRest = 100.0
        var maxRest = 100.0
        var text = textAction("Rest")
        if let resstComponent = entity.getComponent(ofType: EnergyComponent.self) {
            currentRest = resstComponent.current
            maxRest = resstComponent.total
            text = resstComponent.status
        }
        energyBar.updateProgressBar(total: maxRest, current: currentRest, statusName: text)
    }
    
    @objc func nextAction(_ sender: UIButton) {
        nextBlock?()
    }
  
    func setupUI(){
        addSubview(bgView)
        bgView.addSubview(name)
        bgView.addSubview(healthBar)
        bgView.addSubview(emotionBar)
        bgView.addSubview(energyBar)
        bgView.addSubview(movementBoundsBar)
        bgView.addSubview(basicInfo)
        bgView.addSubview(weaponInfo)
        bgView.addSubview(activeJobInfo)
        bgView.addSubview(nextNodeBtn)

    }
    
    func setupLayout(entity:RMEntity){
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
   
      
        let leftPage = 12.0
        let barHeight = 12.0
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
//            make.height.equalTo(labelHeight)
        }
        
        let barPage = 4.0
        /// 屏幕宽度的3分之一
        let barWidth = (UIScreen.screenWidth / 3.0 - leftPage * 2.0 - 3 * barPage) / 4.0
        
        healthBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leftPage)
            make.top.equalTo(name.snp.bottom).offset(5.0)
            make.width.equalTo(barWidth)
            make.height.equalTo(barHeight)
        }
        emotionBar.snp.makeConstraints { make in
            make.left.equalTo(healthBar.snp.right).offset(barPage)
            make.top.equalTo(healthBar.snp.top)
            make.width.equalTo(barWidth)
            make.height.equalTo(barHeight)
        }
        energyBar.snp.makeConstraints { make in
            make.left.equalTo(emotionBar.snp.right).offset(barPage)
            make.top.equalTo(healthBar.snp.top)
            make.width.equalTo(barWidth)
            make.height.equalTo(barHeight)
        }
        movementBoundsBar.snp.makeConstraints { make in
            make.left.equalTo(energyBar.snp.right).offset(barPage)
            make.top.equalTo(healthBar.snp.top)
            make.width.equalTo(barWidth)
            make.height.equalTo(barHeight)
        }
        basicInfo.snp.makeConstraints { make in
            make.top.equalTo(movementBoundsBar.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
//            make.height.equalTo(labelHeight)
        }
        weaponInfo.snp.makeConstraints { make in
            make.top.equalTo(basicInfo.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
//            make.height.equalTo(labelHeight)
        }
        activeJobInfo.snp.makeConstraints { make in
            make.top.equalTo(weaponInfo.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
        }
        
        nextNodeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.height.equalTo(25.0)
        }
        
        setData(entity: entity)
    }
    
    private func setData(entity:RMEntity){
        
        weakEntity = entity
        
        /// 姓名昵称称号,性别
        if let info = entity.getComponent(ofType: BasicInfoComponent.self) {
            name.text = "\(info.nickName),\(info.title)"
            let gender = info.gender == 1 ? textAction("男性") : textAction("女性")
            basicInfo.text = "\(gender),\(textAction("年龄"))\(info.age)"
        }
        
        
        /// 健康状态
        if let healthCom = entity.getComponent(ofType: HealthComponent.self) {
            healthBar.updateProgressBar(total: healthCom.total, current: healthCom.current, statusName: healthCom.status)
        }
        
        /// 心情状态
        if let emotionCom = entity.getComponent(ofType: EmotionComponent.self) {
            emotionBar.updateProgressBar(total: emotionCom.total, current: emotionCom.current, statusName: emotionCom.status)
        }

        /// 精力状态
        if let energyCom = entity.getComponent(ofType: EnergyComponent.self) {
            energyBar.updateProgressBar(total: energyCom.total, current: energyCom.current, statusName: energyCom.status)
        }
        
        /// 活动区域
        if let movementCom = entity.getComponent(ofType: MovementBoundsComponent.self) {
            movementBoundsBar.updateProgressBar(total: movementCom.total, current: movementCom.current, statusName: movementCom.status)
        }
        
        /// 武器
        if let ownerShipCom = entity.getComponent(ofType: OwnershipComponent.self){
            
            
            var weaponEntity:RMEntity?
            for entityId in ownerShipCom.ownedEntityIDS {
                let tempEntity = DBManager.shared.getWeaponEntity(entityId)
                if tempEntity.type == kWeapon {
                    weaponEntity = tempEntity
                    break
                }
            }

            if let weapon = weaponEntity,
                let weaponCom = weapon.getComponent(ofType: WeaponComponent.self){
                weaponInfo.text = "\(textAction("装备："))\(weaponCom.textureName)(\(textAction(weaponCom.getWeaponLevel())))"
            }else{
                weaponInfo.text = textAction("装备：未装备")
            }
        }else{
            weaponInfo.text = textAction("装备：未装备")
        }
        
        ///当前行为
        if let actionCom = entity.getComponent(ofType: ActionStateComponent.self) {
            activeJobInfo.text = textAction(actionCom.getActionType())
        }
        
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
    
    /// 健康值
    lazy var healthBar: BarView = {
        let view = BarView()
        return view
    }()
    
    /// 心情值
    lazy var emotionBar: BarView = {
        let view = BarView()
        return view
    }()
    
    /// 精力值
    lazy var energyBar: BarView = {
        let view = BarView()
        return view
    }()
    
    /// 无限制值
    lazy var movementBoundsBar: BarView = {
        let view = BarView()
        return view
    }()
    
    /// 描述1 性别，年龄
    lazy var basicInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    /// 武器描述
    lazy var weaponInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    /// 正在做的事情描述
    lazy var activeJobInfo: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
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
