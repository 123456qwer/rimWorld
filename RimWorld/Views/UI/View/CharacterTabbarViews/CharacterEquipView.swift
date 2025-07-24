//
//  CharacterEquipView.swift
//  RimWorld
//
//  Created by wu on 2025/5/15.
//

import Foundation
import UIKit

/// 装备
class CharacterEquipView: UIView {
    let bg:UIView = UIView()
    let contentView:UIView = UIView()
    let bgScroll:UIScrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    func updateLayout(_ entity: RMEntity) {
        let views = contentView.subviews
        for v in views { v.removeFromSuperview() }
        
        let leftPage = 12.0
        let lineHeight = 20.0
        let linePage = 5.0
        
        /// 武器、挂件
        var equips:[RMEntity] = []
        /// 护甲、衣着
        var armors:[RMEntity] = []
        /// 持有物
        var goods:[RMEntity]  = []
        
       
        
        /// 防御
        let defenceComponent = entity.getComponent(ofType: DefenseComponent.self) ?? DefenseComponent()
        /// 负重
        let carryingComponent = entity.getComponent(ofType: CarryingCapacityComponent.self) ?? CarryingCapacityComponent()
        /// 温度
        let temperatureComponent = entity.getComponent(ofType: ComfortTemperatureComponent.self) ?? ComfortTemperatureComponent()
        
        
        /// 所拥有的武器、挂件等
        if let ownershipComponent = entity.getComponent(ofType: OwnershipComponent.self) {
            for id in ownershipComponent.ownedEntityIDS {
                /// 添加武器、其他的
                let entity = DBManager.shared.getEntity(id)
                /// 武器、挂件
                if entity.type == kWeapon {
                    equips.append(entity)
                }else if entity.type == kArmor {
                    armors.append(entity)
                }else if entity.type == kMedicine {
                    goods.append(entity)
                }
            }
        }

        
        let carryLabel = createLabel()
        carryLabel.text = textAction("CarryWeight:") + "\(carryingComponent.currentLoad) /" + "\(carryingComponent.maxCapacity) kg"
        
        
        let temperatureLabel = createLabel()
        temperatureLabel.text = textAction("Comfort Temperature Range:") + "\(temperatureComponent.minTolerableTemp)C ~ " + "\(temperatureComponent.maxTolerableTemp)C"
        
        
        let armorTitleLabel = createLabel()
        armorTitleLabel.text = textAction("TotalArmor")
        
        /// 分割线1
        let line1 = UIView()
        line1.backgroundColor = .white
        contentView.addSubview(line1)

        /// 护甲值
        let sharpLabel = createLabel()
        let bluntLabel = createLabel()
        let heatLabel = createLabel()
      
        sharpLabel.text = textAction("SharpArmor") + "          " + "\(defenceComponent.sharpArmor)%"
        bluntLabel.text = textAction("BluntArmor") + "          " + "\(defenceComponent.bluntArmor)%"
        heatLabel.text = textAction("HeatArmor") + "          " + "\(defenceComponent.heatArmor)%"
        
        
        let armorTitleLabel2 = createLabel()
        armorTitleLabel2.text = textAction("Equip")
        
        /// 分割线2
        let line2 = UIView()
        line2.backgroundColor = .white
        contentView.addSubview(line2)
        
        
        /// 武器、挂件
        let weaponBgView = UIView()
        contentView.addSubview(weaponBgView)
        
        var yPage = 0.0
        var index = 0
        /// 武器装备列表
        for equipEntity in equips {
            
            let equipLabel = UILabel()
            equipLabel.textColor = .white
            equipLabel.font = UIFont.systemFont(ofSize: 12.0)
            weaponBgView.addSubview(equipLabel)
            
            let equipImageV = UIImageView()
            weaponBgView.addSubview(equipImageV)
            
            
            if let weaponComponent = equipEntity.getComponent(ofType: WeaponComponent.self){
                equipLabel.text = textAction(weaponComponent.textureName) + "(\(weaponComponent.getWeaponLevel()) \(weaponComponent.durability)%)          " + "\(weaponComponent.weight) kg"
                equipImageV.image = UIImage(named: weaponComponent.textureName)
            }
            
            
            /// 装备图标
            equipImageV.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage * 1.3)
                make.height.equalTo(lineHeight)
                make.width.equalTo(lineHeight)
            }
            /// 装备名称
            equipLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.left.equalTo(equipImageV.snp.right).offset(3.0)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
           
            
            /// 最后一个的时候，计算高度
            if index == equips.count - 1 {
                weaponBgView.snp.makeConstraints { make in
                    make.top.equalTo(line2.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalTo(equipLabel.snp.bottom)
                }
            }
            
            yPage += lineHeight
            index += 1
        }
        /// 未有装备武器的情况下
        if equips.count == 0 {
            let equipLabel = UILabel()
            equipLabel.textColor = .white
            equipLabel.font = UIFont.systemFont(ofSize: 12.0)
            equipLabel.text = textAction("Unequipped")
            weaponBgView.addSubview(equipLabel)
            equipLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
            weaponBgView.snp.makeConstraints { make in
                make.top.equalTo(line2.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(equipLabel.snp.bottom)
            }
            
        }
        
        
        /// 衣着
        let armorTitleLabel3 = createLabel()
        armorTitleLabel3.text = textAction("Clothing")
        
        let line3 = UIView()
        line3.backgroundColor = .white
        contentView.addSubview(line3)
        
        /// 护甲、衣服
        let armorBgView = UIView()
        contentView.addSubview(armorBgView)
        
        yPage = 0
        index = 0
        /// 护甲、衣着列表
        for equipEntity in armors {
            
            let equipLabel = UILabel()
            equipLabel.textColor = .white
            equipLabel.font = UIFont.systemFont(ofSize: 12.0)
            armorBgView.addSubview(equipLabel)
            
            let equipImageV = UIImageView()
            armorBgView.addSubview(equipImageV)
            
            
            if let armorComponent = equipEntity.getComponent(ofType: ArmorComponent.self){
                equipLabel.text = textAction(armorComponent.textureName) + "(\(armorComponent.getWeaponLevel()) \(armorComponent.durability)%)          " + "\(armorComponent.weight) kg"
                equipImageV.image = UIImage(named: armorComponent.textureName)
            }
            
            
            /// 装备图标
            equipImageV.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage * 1.3)
                make.height.equalTo(lineHeight)
                make.width.equalTo(lineHeight)
            }
            /// 装备名称
            equipLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.left.equalTo(equipImageV.snp.right).offset(3.0)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
           
            
            /// 最后一个的时候，计算高度
            if index == armors.count - 1 {
                armorBgView.snp.makeConstraints { make in
                    make.top.equalTo(line3.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.bottom.equalTo(equipLabel.snp.bottom)
                }
            }
            
            yPage += lineHeight
            index += 1
        }
        /// 未有装备护甲的情况下
        if armors.count == 0 {
            let equipLabel = UILabel()
            equipLabel.textColor = .white
            equipLabel.font = UIFont.systemFont(ofSize: 12.0)
            equipLabel.text = textAction("Unequipped")
            armorBgView.addSubview(equipLabel)
            equipLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
            armorBgView.snp.makeConstraints { make in
                make.top.equalTo(line3.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(equipLabel.snp.bottom)
            }
            
        }
        
        /// 货物
        let goodsTitleLabel = createLabel()
        goodsTitleLabel.text = textAction("Goods")
        
        let line4 = UIView()
        line4.backgroundColor = .white
        contentView.addSubview(line4)
        
        yPage = 0
        index = 0
        
        /// 货物
        let goodsBgView = UIView()
        contentView.addSubview(goodsBgView)
        /// 货物列表
        for goodsEntity in goods {
            
            let goodsLabel = UILabel()
            goodsLabel.textColor = .white
            goodsLabel.font = UIFont.systemFont(ofSize: 12.0)
            goodsBgView.addSubview(goodsLabel)
            
            let goodsImageV = UIImageView()
            goodsBgView.addSubview(goodsImageV)
            
            
            if goodsEntity.type == kMedicine {
                if let medicineComponent = goodsEntity.getComponent(ofType: MedicalKitComponent.self) {
                    goodsLabel.text = textAction(medicineComponent.quality) + "x" + "\(medicineComponent.medicineCount)" + "        " + "\(medicineComponent.weight)kg"
                    goodsImageV.image = UIImage(named: medicineComponent.quality)
                }
            }
            
            /// 物品图标
            goodsImageV.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage * 1.3)
                make.height.equalTo(lineHeight)
                make.width.equalTo(lineHeight)
            }
            /// 物品名称
            goodsLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.left.equalTo(goodsImageV.snp.right).offset(3.0)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
           
            
            /// 最后一个的时候，计算高度
            if index == goods.count - 1 {
                goodsBgView.snp.makeConstraints { make in
                    make.top.equalTo(line4.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(yPage + linePage)
                    make.bottom.equalToSuperview().offset(-40.0)
                }
            }
            
            yPage += lineHeight
            index += 1
        }
        
        /// 未有物品的情况下
        if goods.count == 0 {
            let goodsLabel = UILabel()
            goodsLabel.textColor = .white
            goodsLabel.font = UIFont.systemFont(ofSize: 12.0)
            goodsLabel.text = textAction("No Goods")
            goodsBgView.addSubview(goodsLabel)
            goodsLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.leading.equalToSuperview().offset(leftPage)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.height.equalTo(lineHeight)
            }
            goodsBgView.snp.makeConstraints { make in
                make.top.equalTo(line4.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(lineHeight)
                make.bottom.equalToSuperview().offset(-20.0)
            }
        }
        
     
       
        carryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(carryLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        armorTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(linePage)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        line1.snp.makeConstraints { make in
            make.top.equalTo(armorTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(1)
        }
        sharpLabel.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        bluntLabel.snp.makeConstraints { make in
            make.top.equalTo(sharpLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        heatLabel.snp.makeConstraints { make in
            make.top.equalTo(bluntLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        armorTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(heatLabel.snp.bottom).offset(linePage)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        line2.snp.makeConstraints { make in
            make.top.equalTo(armorTitleLabel2.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(0.5)
        }
        armorTitleLabel3.snp.makeConstraints { make in
            make.top.equalTo(weaponBgView.snp.bottom).offset(linePage)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        line3.snp.makeConstraints { make in
            make.top.equalTo(armorTitleLabel3.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(0.5)
        }
        goodsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(armorBgView.snp.bottom).offset(linePage)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(lineHeight)
        }
        line4.snp.makeConstraints { make in
            make.top.equalTo(goodsTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(0.5)
        }
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        contentView.addSubview(label)
        return label
    }
   
    private func setupUI() {
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        bg.backgroundColor = UIColor.BgColor()
        
        addSubview(bg)
        bg.addSubview(bgScroll)
        bgScroll.addSubview(contentView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
