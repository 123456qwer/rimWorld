//
//  TalkTableView.swift
//  RimWorld
//
//  Created by wu on 2025/5/28.
//

import Foundation
import UIKit

class TalkTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var logs:[InteractionLogEntry] = []
    
    var entityID:Int = -1
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        
        self.register(UINib.init(nibName: "TalkCell", bundle: nil), forCellReuseIdentifier: "TalkCell")
        
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        
        self.backgroundColor = .black.withAlphaComponent(0)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadLog(_ entity: RMEntity){
        
        self.entityID = entity.entityID
        let eventComponent = DBManager.shared.getEventLog()
        for log in eventComponent.logs {
            if log.fromEntityID == entityID || log.toEntityID == entityID {
                logs.append(log)
            }
        }
        
        self.reloadData()
    }
  
    
    func reloadAll(){
        let eventComponent = DBManager.shared.getEventLog()
        logs = eventComponent.logs
        self.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    
    /// 共多少组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// 每组几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    /// 每行高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    /// 头视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    /// 尾视图高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    /// 头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    /// 尾视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    /// cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 从重用队列中获取单元格
        let cell = tableView.dequeueReusableCell(withIdentifier: "TalkCell", for: indexPath) as! TalkCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        // 设置单元格的文本内容
        
        let log = logs[indexPath.row]
        
        let fromEntity = DBManager.shared.getEntity(log.fromEntityID)
        let toEntity = DBManager.shared.getEntity(log.toEntityID)
        var fromName = ""
        var toName = ""
        
        if let fromBasic = fromEntity.getComponent(ofType: BasicInfoComponent.self) {
            fromName = fromBasic.nickName
        }
        if let toBasic = toEntity.getComponent(ofType: BasicInfoComponent.self) {
            toName = toBasic.nickName
        }
        
        let text = fromName + "\(textAction("和"))" + toName + log.content
        cell.talkContent.text = text
        
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 处理单元格的点击事件
        print("Selected row \(indexPath.row + 1)")
    }
}
