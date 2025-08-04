//
//  GrowingInfoTableView.swift
//  RimWorld
//
//  Created by wu on 2025/8/4.
//

import Foundation
import UIKit

struct RimWorldCropInfo {
    let crop: RimWorldCrop
    let displayName: String
    let description: String
    let category: String
}

class GrowingInfoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var selectType: RimWorldCrop = .rice
    var changeTypeBlock:(()->Void)?
    
    let rimWorldCrops: [RimWorldCropInfo] = [
        // 粮食类
        RimWorldCropInfo(crop: .rice, displayName: "稻米", description: "生长快，产量适中", category: "粮食"),
        RimWorldCropInfo(crop: .potato, displayName: "土豆", description: "适合贫瘠土壤，生长稳定", category: "粮食"),
        RimWorldCropInfo(crop: .corn, displayName: "玉米", description: "高产但生长周期长", category: "粮食"),
        RimWorldCropInfo(crop: .strawberry, displayName: "草莓", description: "可直接生吃", category: "粮食"),
        
        // 药用类
        RimWorldCropInfo(crop: .healroot, displayName: "愈伤草", description: "可收获草药，用于治疗（需种植8）", category: "药用"),

        // 工业类
        RimWorldCropInfo(crop: .cotton, displayName: "棉花", description: "产出布料", category: "工业"),
        RimWorldCropInfo(crop: .devilstrand, displayName: "恶魔皮菌丝", description: "高耐久布料，生长慢但很强（需要技能10）", category: "工业"),

        // 奢侈品类
        RimWorldCropInfo(crop: .smokeleaf, displayName: "烟叶", description: "制成烟草卷", category: "奢侈品"),
        RimWorldCropInfo(crop: .psychoid, displayName: "迷幻叶", description: "用于制作迷幻药品如G茶、耀魂等", category: "奢侈品"),
        RimWorldCropInfo(crop: .hops, displayName: "啤酒花", description: "用于酿造啤酒", category: "奢侈品")
    ]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.BgColor()
        
        self.delegate = self
        self.dataSource = self
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        
        self.register(UINib(nibName: "SaveAreaCell", bundle: nil), forCellReuseIdentifier: "SaveAreaCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rimWorldCrops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveAreaCell", for: indexPath) as! SaveAreaCell
        cell.backgroundColor = UIColor.BgColor()
        cell.selectionStyle = .none
        
        let crop = rimWorldCrops[indexPath.row]
        cell.goodsName.text = "\(textAction(crop.displayName))\n\(textAction(crop.description))"
        
        if crop.crop == selectType {
            cell.selectButton.isSelected = true
        }else {
            cell.selectButton.isSelected = true
        }
        
        cell.selectBlock = {[weak self] isSelect in
            guard let self = self else {return}
            selectType = crop.crop
            self.reloadData()
            self.changeTypeBlock?()
        }
        
        return cell
    }
    
}
