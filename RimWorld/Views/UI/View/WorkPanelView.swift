//
//  WorkPanelView.swift
//  RimWorld
//
//  Created by wu on 2025/5/6.
//

import Foundation
import UIKit

class WorkPanelView: UIView {
    
    var clickWorkLevelBlock:((UIButton) -> Void)?
    let workTypes: [WorkType] = WorkType.allCases
    let workTypeStrings: [String] = WorkType.allCases.map { $0.rawValue }
    let userWidth:CGFloat = 60.0
    

    var userCount:Int = 3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        setupUI()
        //        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(_ entitys:[RMEntity]) {
        
        
        userCount = entitys.count
        
        
        addSubview(bigBgView)
        bigBgView.addSubview(tipLabel)
        addSubview(workHeaderView)
        addSubview(characterBgScrollView)
        characterBgScrollView.addSubview(characterPanelView)
        
        addSubview(close)
        
        workTitleSenders.forEach { workHeaderView.addSubview($0) }
        workSeparatorLines.forEach { workHeaderView.addSubview($0) }
        
        workUserLineViews.forEach{ characterPanelView.addSubview($0) }
        
        setupLayout(entitys)
    }
    
    private func setupLayout(_ entitys:[RMEntity]) {
        
        tipLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20.0)
            make.centerX.equalToSuperview()
        }
        
        bigBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-35)
            make.leading.equalToSuperview().offset(-15)
            make.trailing.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(15)
        }
        
        close.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(50.0)
        }
        
        //        characterBgScrollView.backgroundColor = .darkGray
        characterBgScrollView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        characterPanelView.snp.makeConstraints { make in
            make.edges.equalTo(characterBgScrollView.contentLayoutGuide)
            make.width.equalTo(characterBgScrollView.frameLayoutGuide)
        }
        
        workHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        
        
        layoutWorkTitleLabels()
        layoutWorkSeparatorLines()
        
        var tempUserView:UIView?
        var number = 100
        var allIndex = 0
        
        
        for userView in workUserLineViews{
            
            /// 角色
            let character = entitys[allIndex]
            
            let workPrioritysComponent = character.getComponent(ofType: WorkPriorityComponent.self)
            /// 优先级
            let workPrioritys = workPrioritysComponent!.getWorkPriorityArr()
            /// 设置角色横栏snp
            userView.snp.makeConstraints { make in
                if let uV = tempUserView {
                    make.top.equalTo(uV.snp.bottom)
                }else{
                    make.top.equalToSuperview()
                }
                make.left.equalToSuperview().offset(userWidth)
                make.right.equalToSuperview().offset(0)
                make.height.equalTo(40.0)
                
                if allIndex == workUserLineViews.count - 1{
                    make.bottom.equalToSuperview()
                }
            }
            tempUserView = userView
            
            
            /// 角色图标
            let head = UIImageView()
            head.backgroundColor = .orange
            characterPanelView.addSubview(head)
            
            let leftPage = 5
            head.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(-leftPage)
                make.width.height.equalTo(userWidth / 3.0)
                make.centerY.equalTo(tempUserView!.snp.centerY).offset(-2.5)
            }
            
            /// 角色名字
            let nameBg = UIScrollView()
//            nameBg.backgroundColor = .yellow
            characterPanelView.addSubview(nameBg)
            
            let nameContentView = UIView()
//            nameContentView.backgroundColor = .black
            nameBg.addSubview(nameContentView)
            
            let basicInfo = character.getComponent(ofType: BasicInfoComponent.self)!
            let skill = character.getComponent(ofType: SkillComponent.self)!
            
            let nameLabel = UILabel()
            nameLabel.text = "\(basicInfo.firstName)\(basicInfo.lastName),\(basicInfo.title)"
            nameLabel.textColor = .white
            nameLabel.numberOfLines = 0
            nameLabel.font = UIFont.systemFont(ofSize: 11.0)
            nameContentView.addSubview(nameLabel)
            
            nameBg.snp.makeConstraints { make in
                make.top.equalTo(tempUserView!.snp.top).offset(-5)
                make.bottom.equalTo(tempUserView!.snp.bottom)
                make.left.equalTo(head.snp.right).offset(leftPage)
                make.right.equalTo(tempUserView!.snp.left).offset(-leftPage)
            }
            nameContentView.snp.makeConstraints { make in
                make.edges.equalTo(nameBg.contentLayoutGuide)
                make.height.equalTo(nameBg.frameLayoutGuide)
            }
            nameLabel.snp.makeConstraints { make in
                make.top.left.bottom.right.equalToSuperview()
            }
            
            
            /// 优先级按钮
            var btns = [UIButton]()
            for index in 0..<workTypes.count{
                let sender = createActionLevelSender(workPriority: workPrioritys[index])
                sender.tag = number + index
                sender.addTarget(self, action: #selector(workTap), for: .touchUpInside)
                btns.append(sender)
                userView.addSubview(sender)
                
                let basicInfo = character.getComponent(ofType: BasicInfoComponent.self)!
                addPreferenceStar(workType: workTypes[index], skillComponent: skill, sender: sender)
                
            }
            layoutActionLevelSenders(senders: btns)
            
            number += 100
            allIndex += 1
        }
        
    }
    
    /// 根据类型判断添加几颗星
    private func addPreferenceStar(workType:WorkType,
                                   skillComponent:SkillComponent,
                                   sender:UIButton){
        
        /// 偏好程度
        let startCount = skillComponent.preferenceCountForWork(workType: workType)
        if startCount < 0 { return }
        
        for index in 0..<startCount{
            let imageV = UIImageView()
            imageV.image = UIImage(named: "workPreference")
            sender.addSubview(imageV)
            
            /// 原图片大小
            let width = 395.0
            let height = 550.0
            let changeWidth = 8.0
            let changeHeight = changeWidth / width * height
            imageV.alpha = 0.7
            imageV.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.width.equalTo(changeWidth)
                make.height.equalTo(changeHeight)
                make.trailing.equalToSuperview().offset(-Double(index) * changeWidth)
            }
        }
        
    }
    
    /// 顶部内容布局
    private func layoutWorkTitleLabels() {
        let width = labelWidth
        var previousSender: UIButton?
        
        for (index, sender) in workTitleSenders.enumerated() {
            sender.snp.makeConstraints {
                if index % 2 == 0 {
                    $0.top.equalToSuperview().offset(-4)
                } else {
                    $0.bottom.equalToSuperview().offset(-4)
                }
                if let previous = previousSender {
                    $0.left.equalTo(previous.snp.centerX)
                } else {
                    $0.left.equalToSuperview().offset(userWidth - width / 2.0)
                }
                $0.width.equalTo(width * 2)
                $0.height.equalToSuperview().multipliedBy(0.5)
            }
            previousSender = sender
        }
    }
    
    /// 分割线布局
    private func layoutWorkSeparatorLines() {
        for (index, line) in workSeparatorLines.enumerated() {
            guard index < workTitleSenders.count else { continue }
            let sender = workTitleSenders[index]
            line.snp.makeConstraints {
                $0.top.equalTo(sender.snp.bottom).offset(-5)
                $0.centerX.equalTo(sender.snp.centerX)
                $0.bottom.equalToSuperview()
                $0.width.equalTo(2)
            }
        }
    }
    
    /// 人物当前任务按钮布局
    private func layoutActionLevelSenders(senders: [UIButton]) {
        
        let width = labelWidth
        
        var previousSender: UIButton?
        for (index, _) in senders.enumerated() {
            guard index < senders.count else { continue }
            let sender = senders[index]
            sender.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(width)
                make.height.equalTo(width)
                if let previous = previousSender {
                    make.left.equalTo(previous.snp.right)
                }else{
                    make.left.equalToSuperview()
                }
            }
            previousSender = sender
        }
    }
    
    /// 背景
    lazy var bigBgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ml_color(hexValue: 0x16181b)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    /// 优先提示
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.text = textAction("<= 高优先级                    低优先级 =>")
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        return label
    }()
    
    /// 顶部标签背景
    lazy var workHeaderView:UIView = {
        let view = UIView()
//        view.backgroundColor = .yellow
        return view
    }()
    
    /// 可滑动的
    lazy var characterBgScrollView:UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    /// 人物列表背景
    lazy var characterPanelView:UIView = {
        let view = UIView()
        return view
    }()
    
    /// 顶部标签按钮
    lazy var workTitleSenders: [UIButton] = workTypeStrings.map {
        createButton(with: $0)
    }
    /// 标签底部分割线
    lazy var workSeparatorLines: [UIView] = workTypes.map { _ in
        createLineView()
    }
    
    /// 每一行的玩家角色
    lazy var workUserLineViews: [UIView] = {
        var views = [UIView]()
        for index in 0..<userCount{
            let view = UIView()
//            view.backgroundColor = UIColor.yellow
            views.append(view)
        }
        return views
    }()
    
    /// 关闭按钮
    lazy var close: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .orange
        btn.setTitle(textAction("关闭"), for: .normal)
        return btn
    }()
    
    
    private func createButton(with text: String) -> UIButton {
        let sender = UIButton(type: .custom)
        sender.setTitle(textAction(text), for: .normal)
        sender.titleLabel!.textColor = .black
        sender.titleLabel!.textAlignment = .center
//        sender.backgroundColor = .lightGray
        sender.titleLabel!.numberOfLines = 0
        sender.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
        return sender
    }

    private func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.ml_color(hexValue: 0x525657)
        return view
    }
    
    /// 创建对应人物的工作优先级
    private func createActionLevelSender(workPriority:Int) -> UIButton {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 2.0
        btn.layer.borderColor = UIColor.ml_color(hexValue: 0x333536).cgColor
        btn.layer.borderWidth = 2.0
        if workPriority == 0{
            btn.setTitle("", for: .normal)
        }else{
            btn.setTitle("\(workPriority)", for: .normal)
        }
        btn.backgroundColor = UIColor.ml_color(hexValue: 0x242424)
        changeSenderTitleColor(btn)
        if workPriority == -1{
            btn.isHidden = true
        }
        return btn
    }
    
    private var labelWidth: CGFloat {
        return (UIScreen.screenWidth / 6.0 * 5.0 - userWidth) / CGFloat(workTypes.count)
    }
    
    
    deinit {
        print("WorkPanelView 已释放")
    }
}


extension WorkPanelView {
    
    /// 类型点击
    @objc func workTap(_ sender:UIButton) {
        clickWorkLevelBlock?(sender)
    }
    
    /// 改变按钮颜色
    func changeSenderTitleColor(_ sender:UIButton){

        
        var nowLevel = sender.titleLabel?.text ?? "0"
        if nowLevel == "" {
            nowLevel = "0"
        }
        
        if nowLevel == "1"{
            sender.setTitleColor(UIColor.ml_color(hexValue: 0x23ce00), for: .normal)
        }else if nowLevel == "2"{
            sender.setTitleColor(UIColor.ml_color(hexValue: 0xafa462), for: .normal)
        }else if nowLevel == "3"{
            sender.setTitleColor(UIColor.ml_color(hexValue: 0x817671), for: .normal)
        }else {
            sender.setTitleColor(UIColor.ml_color(hexValue: 0x9f9f9f), for: .normal)
        }
    }
}
