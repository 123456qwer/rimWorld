//
//  SaveAreaTableView.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import Foundation
import UIKit

class StorageInfoTabelView: UITableView,UITableViewDataSource,UITableViewDelegate {
  
    var reloadBlock:(()->Void)?
    let headerHeight:CGFloat = 30.0
    var allow:[String:[String:Bool]] = [textAction("Raw Meterial"):[textAction("Wood"):true]]
    
    let sectionTitles = [
        textAction("Raw Meterial"),
        textAction("Medicine")
    ]
    
    var isSectionExpanded: [Int: Bool] = [:]
    
    weak var areaBasicComponent:StorageInfoComponent?

    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.BgColor()
        
        self.delegate = self
        self.dataSource = self
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        
        self.register(UINib(nibName: "SaveAreaCell", bundle: nil), forCellReuseIdentifier: "SaveAreaCell")
    }
    
    func setData(_ entity: RMEntity) {
        guard let basicComponent = entity.getComponent(ofType: StorageInfoComponent.self) else {
            return
        }
        areaBasicComponent = basicComponent
        allow = basicComponent.allow
        for i in 0..<allow.count {
            isSectionExpanded[i] = true
        }
        self.reloadData()
    }

    /// 取消全部
    func cancelAllAction() {
        for sectionKey in sectionTitles {
            if let sectionItems = self.allow[sectionKey] {
                // 使用 mapValues 统一修改所有值为 true
                let updatedItems = sectionItems.mapValues { _ in false }
                self.allow[sectionKey] = updatedItems
            }
        }
        
        areaBasicComponent?.allow = self.allow
        self.reloadData()
        reloadBlock?()
    }
    
    /// 存储全部
    func allowAllAction() {
        for sectionKey in sectionTitles {
            if let sectionItems = self.allow[sectionKey] {
                // 使用 mapValues 统一修改所有值为 true
                let updatedItems = sectionItems.mapValues { _ in true }
                self.allow[sectionKey] = updatedItems
            }
        }
        
        areaBasicComponent?.allow = self.allow
        self.reloadData()
        reloadBlock?()
    }
    
    /// 点击section上的选择项
    @objc func sectionSelectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let sectionKey = sectionTitles[sender.tag]
        if let sectionItems = self.allow[sectionKey] {
            // 使用 mapValues 统一修改所有值为 true
            let updatedItems = sectionItems.mapValues { _ in sender.isSelected }
            self.allow[sectionKey] = updatedItems
        }
        
        areaBasicComponent?.allow = self.allow
        self.reloadData()
        reloadBlock?()
    }
    
    
    @objc func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        let current = isSectionExpanded[section] ?? true
        isSectionExpanded[section] = !current

        // 使用动画刷新当前 section
        self.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        let items = allow[sectionKey] ?? [:]
        
        if isSectionExpanded[section] == true {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveAreaCell", for: indexPath)
        
        if let cell = cell as? SaveAreaCell {
            
            let sectionKey = sectionTitles[indexPath.section]
            let items = allow[sectionKey] ?? [:]
            let itemArray = Array(items.keys)
            let itemName = itemArray[indexPath.row]
            let itemValue = items[itemName] ?? true
            cell.goodsName.text = itemName
            cell.selectButton.isSelected = itemValue
            
            /// 存储一下
            cell.selectBlock = {[weak self] isSelect in
                guard let self = self else {return}
                // 取出原始的 items 字典
                var sectionItems = self.allow[sectionKey] ?? [:]
              
                // 修改值
                sectionItems[itemName] = isSelect
              
                // 再写回去原字典中
                self.allow[sectionKey] = sectionItems
              
                areaBasicComponent?.allow = self.allow
                
                self.reloadData()
                reloadBlock?()
            }
        }
        
        cell.backgroundColor = UIColor.BgColor()
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionKey = sectionTitles[section]
      
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "downArrow"), for: .selected)
        button.setImage(UIImage(named: "rightArrow"), for: .normal)
        button.setTitle(sectionKey, for: .normal)
        button.setTitle(sectionKey, for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        let font = button.titleLabel!.font
        let width = MathUtils.textWidth(sectionKey, font: font ?? UIFont.systemFont(ofSize: 16)) + 30.0
        button.frame = CGRect(x: 0, y: (headerHeight - 20) / 2.0, width: width, height: 20.0)
        button.tag = section

        let bgV = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: headerHeight))
//        bgV.backgroundColor = .orange
        bgV.addSubview(button)
        
        let lineView = UIView(frame: CGRect(x: 0, y: headerHeight - 1, width: self.frame.size.width, height: 1.0))
        lineView.backgroundColor = UIColor.ml_color(hexValue: 0xe3e3e3)
        bgV.addSubview(lineView)
        
        button.isSelected = isSectionExpanded[section] ?? true
        button.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        
        ///是否全选
        let allSelected = self.allow[sectionKey]?.allSatisfy{ $0.value == true }
        
        /// 选中状态
        let selectBtn = UIButton(type: .custom)
        selectBtn.frame = CGRect(x: self.frame.size.width - 25 - 12, y: (headerHeight - 25) / 2.0, width: 25, height: 25)
        selectBtn.setImage(UIImage(named: "no"), for: .normal)
        selectBtn.setImage(UIImage(named: "yes"), for: .selected)
        selectBtn.isSelected = allSelected ?? false
        selectBtn.tag = section
        selectBtn.addTarget(self, action: #selector(sectionSelectAction), for: .touchUpInside)
        bgV.addSubview(selectBtn)

        return bgV
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
