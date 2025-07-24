//
//  CharacterDetailInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/5/10.
//

import Foundation
import UIKit

/// 角色
class CharacterDetailInfoView: UIView {

    // MARK: - Subviews
    /// 名字，昵称+名+姓
    private let nameLabel = UILabel()
    /// 性别，年龄
    private let genderAgeLabel = UILabel()
    /// 种族
    private let raceBtn = UIButton(type: .custom)
    /// 头衔
    private let roleButton = UIButton()
    /// 特性标题
    private let traitsTitleLabel = UILabel()
    /// 特性列表
    private let traitsStackView = UIView()
    /// 无法从事标题
    private let incapableTitleLabel = UILabel()
    /// 无法从事列表
    private let incapableView = UIView()
    /// 能力
    private let powerView = UIView()
    
    
    private let leftContentView  = UIView()
    private let rightContentView = UIView()
    private let leftScrollView   = UIScrollView()
    private let rightScrollView  = UIScrollView()
    private let bg = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        
        self.backgroundColor = UIColor.BgColor()
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        
        addSubview(bg)
        bg.addSubview(leftScrollView)
        bg.addSubview(rightScrollView)
        leftScrollView.addSubview(leftContentView)
        rightScrollView.addSubview(rightContentView)
        
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        setupLeftView()
        setupRightView()
    }
    
    
    // MARK: - 右侧视图 -
    /// 右侧内容
    func setupRightView(){
        
        rightScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        rightContentView.snp.makeConstraints { make in
            make.edges.equalTo(rightScrollView.contentLayoutGuide)
            make.width.equalTo(rightScrollView.frameLayoutGuide)
        }
        
        
        
    }
    /// 设置右侧视图Layout
    func setupRightLayout(_ entity: RMEntity) {
        
        let skills = SkillType.allCases
        var yPage = 30.0
        let bgHeight = 12.0
        
        let leftPage = 12.0

        var maxLabelWidth = 0.0
        let titleFont = UIFont.systemFont(ofSize: 12.0)
        /// 文字最大宽度
        for skill in skills {
            let labelWidth = textAction(skill.rawValue).width(usingFont: titleFont)
            if maxLabelWidth < labelWidth {
                maxLabelWidth = labelWidth
            }
        }
        
        let skillComponent = entity.getComponent(ofType: SkillComponent.self)!
        
        var index = 0
        for skill in skills {
            let bg = UIView()
//            bg.backgroundColor = UIColor.randomColor()
            rightContentView.addSubview(bg)
            
       
            
            if index == skills.count - 1 {
                bg.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(yPage)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview().offset(-leftPage)
                    make.height.equalTo(bgHeight)
                    make.bottom.equalToSuperview().offset(-20)
                }
            }else{
                bg.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(yPage)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview().offset(-leftPage)
                    make.height.equalTo(bgHeight)
                }
            }
            
            /// 技能名称
            let label = UILabel()
            label.text = textAction(skill.rawValue)
            label.textColor = .white
//            label.backgroundColor = .black
            label.font = UIFont.systemFont(ofSize: 12.0)
            bg.addSubview(label)
            
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(maxLabelWidth)
                make.leading.equalToSuperview().offset(leftPage)
            }
            
         
            /// 火热值
            let preference = skillComponent.preferenceCountForSkill(skillType: skill)
            /// 原图片大小
            let width = 395.0
            let height = 550.0
            let changeWidth = 8.0
            let changeHeight = changeWidth / width * height
            /// 图片间距
            let imagePage = 2.0
            /// 技能值距离图片间距
            let smallLeftPage = 2.0
            if preference > 0{
             
                for index in 0..<preference {
                    let imageV = UIImageView()
                    imageV.image = UIImage(named: "workPreference")
                    bg.addSubview(imageV)
                    imageV.alpha = 0.7
                    if index == 0 {
                        imageV.snp.makeConstraints { make in
                            make.centerY.equalToSuperview()
                            make.left.equalTo(label.snp.right).offset(imagePage)
                            make.width.equalTo(changeWidth)
                            make.height.equalTo(changeHeight)
                        }
                    }else {
                        imageV.snp.makeConstraints { make in
                            make.centerY.equalToSuperview()
                            make.left.equalTo(label.snp.right).offset(imagePage + changeWidth)
                            make.width.equalTo(changeWidth)
                            make.height.equalTo(changeHeight)
                        }
                    }
                }
            }
           
            let maxSkillValue = 20.0
            /// 技能值
            let skillValue = skillComponent.valueCountForSkill(skillType: skill)
            if preference < 0 {
                let view = UIView()
                view.backgroundColor = UIColor.white
                bg.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(label.snp.right).offset(changeWidth * 2.0 + imagePage + smallLeftPage)
                    make.width.equalTo(5)
                    make.height.equalTo(1.0)
                }
                
            }else{
               
                /// 总视图总宽
                let widthPercent = 1.5/3.0
                /// 剩余可计算百分比的宽度
                let allLastWidth = UIScreen.screenWidth * widthPercent / 2.0 - maxLabelWidth - changeWidth * 2.0 - imagePage - smallLeftPage - leftPage
                let skillPercent = CGFloat(skillValue) / maxSkillValue
                let view = UIView()
                view.backgroundColor = UIColor.btnBgColor()
                bg.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(label.snp.right).offset(changeWidth * 2.0 + imagePage + smallLeftPage)
                    make.width.equalTo(allLastWidth * skillPercent)
                }
                
                /// 技能点数
                let skillLabel = UILabel()
                skillLabel.text = "\(skillValue)"
                skillLabel.font = UIFont.systemFont(ofSize: 11.5)
                skillLabel.textColor = .white
                view.addSubview(skillLabel)
                
                skillLabel.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.leading.equalToSuperview().offset(2.0)
                }
            }
     
            
            yPage = yPage + bgHeight + 3.0
            index += 1
        }
        
    }
  
    
    
    
    
    // MARK: - 左侧视图 -
    /// 左侧内容
    func setupLeftView(){
        
        let smallFont = UIFont.systemFont(ofSize: 12.0)

        /// 名字
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0

        /// 性别、年龄
        genderAgeLabel.font = smallFont
        genderAgeLabel.textColor = .white

        /// 种族
        raceBtn.setTitleColor(.white, for: .normal)
        raceBtn.titleLabel?.font = smallFont
        raceBtn.backgroundColor = UIColor.btnBgColor()
        
        /// 称号
        roleButton.setTitleColor(.white, for: .normal)
        roleButton.titleLabel?.font = smallFont
        roleButton.backgroundColor = UIColor.btnBgColor()

        /// 特性标题
        traitsTitleLabel.font = smallFont
        traitsTitleLabel.textColor = .yellow
        traitsTitleLabel.text = textAction("Traits")

        /// 无法从事工作标题
        incapableTitleLabel.font = smallFont
        incapableTitleLabel.textColor = .yellow
        incapableTitleLabel.text = textAction("Unavailable")
        
        
        leftContentView.ml_addSubviews([nameLabel,genderAgeLabel,raceBtn,roleButton,traitsTitleLabel,traitsStackView,incapableTitleLabel,incapableView,powerView])
        

    }
    /// 设置左侧视图Layout
    func setupLeftLayout(_ entity: RMEntity) {
        
        let leftPage = 12.0

        leftScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        leftContentView.snp.makeConstraints { make in
            make.edges.equalTo(leftScrollView.contentLayoutGuide)
            make.width.equalTo(leftScrollView.frameLayoutGuide)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
        }
        genderAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2.0)
            make.leading.equalToSuperview().offset(leftPage)
        }
        raceBtn.snp.makeConstraints { make in
            make.centerY.equalTo(genderAgeLabel.snp.centerY)
            make.left.equalTo(genderAgeLabel.snp.right).offset(2.0)
            make.height.equalTo(15.0)
        }
        roleButton.snp.makeConstraints { make in
            make.top.equalTo(raceBtn.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(leftPage)
            make.height.equalTo(15.0)
        }
        traitsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(roleButton.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(leftPage)
        }
        traitsStackView.snp.makeConstraints { make in
            make.top.equalTo(traitsTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(50.0)
        }
        incapableTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(traitsStackView.snp.bottom).offset(12.0)
            make.leading.equalToSuperview().offset(leftPage)
        }
        incapableView.snp.makeConstraints { make in
            make.top.equalTo(incapableTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(50.0)
        }
        powerView.snp.makeConstraints { make in
            make.top.equalTo(incapableView.snp.bottom).offset(18.0)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
       
        powerView.backgroundColor = .orange
        setupLeftData(entity)
    }
    /// 设置左侧数据
    func setupLeftData(_ entity: RMEntity) {
        /// 昵称、姓、名、性别、年龄、种族、头衔
        if let info = entity.getComponent(ofType: BasicInfoComponent.self) {
            nameLabel.text = "\(info.nickName),\(info.firstName) \(info.lastName)"
            let gender = info.gender == 1 ? textAction("男性") : textAction("女性")
            genderAgeLabel.text = "\(gender),\(textAction("年龄"))\(info.age)"
            let race = textAction(SpeciesType(rawValue: info.race)?.displayName ?? "Human")
            raceBtn.setTitle(race, for: .normal)
            //            raceBtn.setImage(UIImage(named: "狙击枪"), for: .normal)
            roleButton.setTitle(info.title, for: .normal)
        }
        
        /// 特性
        if let trait = entity.getComponent(ofType: TraitComponent.self) {
          
            let traits = trait.traits.components(separatedBy: ",")
            var btnTitles:[String] = []
            /// 添加特性
            for t in traits{
                let row = CharacterTrait(rawValue: Int(t)!)
                let title = row?.traitDisplayName ?? "无"
                btnTitles.append(textAction(title))
            }
            
            createBtns(contentView: traitsStackView,
                       btnsTitle: btnTitles,
                       topView:traitsTitleLabel)
        }
        
        /// 无法从事项目
        if let skill = entity.getComponent(ofType: SkillComponent.self) {
            let workTypes: [WorkType] = WorkType.allCases
            var btnTitles:[String] = []
            for workType in workTypes {
                let work = skill.preferenceCountForWork(workType: workType)
                if work == -1{
                    btnTitles.append(textAction(workType.rawValue))
                }
            }
            createBtns(contentView: incapableView,
                       btnsTitle: btnTitles,
                       topView: incapableTitleLabel)
        }
        
    }
    
    
}



/// 多个按钮顺序排列
extension CharacterDetailInfoView {
    
    /// 创建等分按钮
    func createBtns(contentView:UIView,
                    btnsTitle:[String],
                    topView:UIView){
        
        contentView.layoutIfNeeded()
        let containerWidth = contentView.bounds.size.width // 父视图宽度（可以用 parentView.bounds.width 动态获取）
        let btnHeight: CGFloat = 15.0
        let spacing: CGFloat = 4.0
        var xPage: CGFloat = 0.0
        var yPage: CGFloat = 0.0
        
        var tempBtn:UIButton?
        /// 添加特性
        for title in btnsTitle{
            
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.backgroundColor = UIColor.btnBgColor()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            
            // 加上内边距等扩展宽度
            let btnWidth = btn.intrinsicContentSize.width + kBtnHorizontalPadding

            // 判断是否需要换行
            if xPage + btnWidth > containerWidth {
                // 换行
                xPage = 0.0
                yPage += btnHeight + spacing
            }

            contentView.addSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(yPage)
                make.left.equalToSuperview().offset(xPage)
                make.height.equalTo(btnHeight)
                make.width.equalTo(btnWidth)
            }

            // 更新下一个按钮起始点
            xPage += btnWidth + spacing
            tempBtn = btn
        }
        
        /// 视图更新
        if let btn = tempBtn {
            let leftPage = 12.0
            contentView.snp.removeConstraints()
            contentView.snp.makeConstraints { make in
                make.top.equalTo(topView.snp.bottom).offset(2.0)
                make.leading.equalToSuperview().offset(leftPage)
                make.trailing.equalToSuperview().offset(-leftPage)
                make.bottom.equalTo(btn.snp.bottom)
            }
        }
        
    }
}
