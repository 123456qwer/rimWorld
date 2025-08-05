//
//  CharacterMoodStatusView.swift
//  RimWorld
//
//  Created by wu on 2025/5/13.
//

import Foundation
import UIKit
import Combine

/// 需求
class CharacterMoodStatusView: UIView {
    
    var cancellables = Set<AnyCancellable>()

    private let bg = UIView()
    private let leftContentView   = UIView()
    private let rightContentView  = UIView()
    private let leftScrollView    = UIScrollView()
    
    /// 饮食标题
    private let nutritionLabel = UILabel()
    /// 饮食
    private let nutritionBarView = BarView()
    
    /// 休息标题
    private let restLabel = UILabel()
    /// 休息
    private let restBarView = BarView()
    
    /// 娱乐标题
    private let joyLabel = UILabel()
    /// 娱乐
    private let joyBarView = BarView()
    
    
    /// 美观标题
    private let aestheticLabel = UILabel()
    /// 美观
    private let aestheticBarView = BarView()
    
    /// 舒适度标题
    private let comfortLabel = UILabel()
    /// 舒适度
    private let comfortBarView = BarView()
    
    /// 室外标题
    private let outdoorLabel = UILabel()
    /// 室外
    private let outdoorBarView = BarView()
    
    /// 心情标题
    private let moodLabel = UILabel()
    /// 心情
    private let moodBarView = BarView()
    
    /// 具体心情描述
    private let moodDetailView = MoodDetailView()

    /// 更新各种值
    weak var weakEntity:RMEntity?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        RMInfoViewEventBus.shared.publisher().sink {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .updateMoodInfo:
                self.updateHunger()
                self.updateEnergy()
                self.updateJoy()
            default:
                break
            }

        }.store(in: &cancellables)
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
  
    /// 饥饿值
    func updateHunger() {
        
        guard let entity = weakEntity else { return }
        
        /// 饥饿度
        var currentNutrition = 100.0
        var maxNutrition = 100.0
        if let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self) {
            currentNutrition = nutritionComponent.current
            maxNutrition = nutritionComponent.total
        }
        
        nutritionBarView.updateProgressBar(total: maxNutrition, current: currentNutrition, statusName: "")
    }
   
    /// 休息值
    func updateEnergy() {
        
        guard let entity = weakEntity else { return }
        /// 休息值
        var currentRest = 100.0
        var maxRest = 100.0
        if let resstComponent = entity.getComponent(ofType: EnergyComponent.self) {
            currentRest = resstComponent.current
            maxRest = resstComponent.total
        }
        restBarView.updateProgressBar(total: maxRest, current: currentRest, statusName: "")
    }
    
    /// 娱乐值
    func updateJoy() {
        
        guard let entity = weakEntity else { return }
        
        var currentJoy = 100.0
        var maxJoy = 100.0
        if let joyComponent = entity.getComponent(ofType: JoyComponent.self) {
            currentJoy = joyComponent.current
            maxJoy = joyComponent.total
        }
        joyBarView.updateProgressBar(total: maxJoy, current: currentJoy, statusName: "")
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        
        self.backgroundColor = UIColor.BgColor()
        
        bg.layer.borderColor = UIColor.white.cgColor
        bg.layer.borderWidth = 2.0
        
        let bigFont = UIFont.systemFont(ofSize: 14.0)
        let smallFont = UIFont.systemFont(ofSize: 12.0)
        
        nutritionLabel.text = textAction("Nutrition")
        nutritionLabel.textColor = UIColor.white
        nutritionLabel.font = bigFont
        
        restLabel.text = textAction("Rest")
        restLabel.textColor = UIColor.white
        restLabel.font = bigFont
        
        joyLabel.text = textAction("Joy")
        joyLabel.textColor = UIColor.white
        joyLabel.font = bigFont
        
        
        aestheticLabel.text = textAction("Aesthetic")
        aestheticLabel.textColor = UIColor.white
        aestheticLabel.font = smallFont
        
        comfortLabel.text = textAction("Comfort")
        comfortLabel.textColor = UIColor.white
        comfortLabel.font = smallFont
        
        outdoorLabel.text = textAction("Outdoor")
        outdoorLabel.textColor = UIColor.white
        outdoorLabel.font = smallFont
        
        
        moodLabel.text = textAction("Mood")
        moodLabel.textColor = UIColor.white
        moodLabel.font = bigFont
        
        
        addSubview(bg)
        bg.addSubview(leftScrollView)
        bg.addSubview(rightContentView)
        leftScrollView.addSubview(leftContentView)

        

        leftContentView.ml_addSubviews([nutritionLabel,restLabel,joyLabel,aestheticLabel,comfortLabel,outdoorLabel,nutritionBarView,restBarView,joyBarView,aestheticBarView,comfortBarView,outdoorBarView])
        
        rightContentView.ml_addSubviews([moodLabel,moodBarView,moodDetailView])

        
        setupLayout()
        
    }
    
    private func setupLayout() {
        bg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftScrollView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1/3.0)
        }
        leftContentView.snp.makeConstraints { make in
            make.edges.equalTo(leftScrollView.contentLayoutGuide)
            make.width.equalTo(leftScrollView.frameLayoutGuide)
        }
        rightContentView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(2/3.0)
        }
    }
    
    
    /// 饮食、休息、娱乐   美观，舒适，室外
    func setupLeftLayout(_ entity: RMEntity) {
        
        weakEntity = entity
        
        let leftPage = 12.0
        let smallLeftPage = leftPage * 5.0
        let barHeight = 15.0
        let smallBarHeight = 10.0
        let bigPage = 3.0
        let smallPage = 3.0
        nutritionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.leading.equalToSuperview().offset(leftPage)
        }
        nutritionBarView.snp.makeConstraints { make in
            make.top.equalTo(nutritionLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(barHeight)
        }
        restLabel.snp.makeConstraints { make in
            make.top.equalTo(nutritionBarView.snp.bottom).offset(bigPage)
            make.leading.equalToSuperview().offset(leftPage)
        }
        restBarView.snp.makeConstraints { make in
            make.top.equalTo(restLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(barHeight)
        }
        joyLabel.snp.makeConstraints { make in
            make.top.equalTo(restBarView.snp.bottom).offset(bigPage)
            make.leading.equalToSuperview().offset(leftPage)
        }
        joyBarView.snp.makeConstraints { make in
            make.top.equalTo(joyLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(barHeight)
        }
        aestheticLabel.snp.makeConstraints { make in
            make.top.equalTo(joyBarView.snp.bottom).offset(bigPage * 3.0)
            make.leading.equalToSuperview().offset(leftPage)
        }
        aestheticBarView.snp.makeConstraints { make in
            make.top.equalTo(aestheticLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-smallLeftPage)
            make.height.equalTo(smallBarHeight)
        }
        comfortLabel.snp.makeConstraints { make in
            make.top.equalTo(aestheticBarView.snp.bottom).offset(smallPage)
            make.leading.equalToSuperview().offset(leftPage)
        }
        comfortBarView.snp.makeConstraints { make in
            make.top.equalTo(comfortLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-smallLeftPage)
            make.height.equalTo(smallBarHeight)
        }
        outdoorLabel.snp.makeConstraints { make in
            make.top.equalTo(comfortBarView.snp.bottom).offset(smallPage)
            make.leading.equalToSuperview().offset(leftPage)
        }
        outdoorBarView.snp.makeConstraints { make in
            make.top.equalTo(outdoorLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-smallLeftPage)
            make.height.equalTo(smallBarHeight)
            make.bottom.equalToSuperview().offset(-20)
        }

        /// 饥饿度
        var currentNutrition = 100.0
        var maxNutrition = 100.0
        if let nutritionComponent = entity.getComponent(ofType: NutritionComponent.self) {
            currentNutrition = nutritionComponent.current
            maxNutrition = nutritionComponent.total
            let p1 = nutritionComponent.threshold / maxNutrition
            nutritionBarView.setThreshold(percents: [p1])
        }
        
        nutritionBarView.updateProgressBar(total: maxNutrition, current: currentNutrition, statusName: "")
        
        
        /// 休息值
        var currentRest = 100.0
        var maxRest = 100.0
        if let resstComponent = entity.getComponent(ofType: EnergyComponent.self) {
            currentRest = resstComponent.current
            maxRest = resstComponent.total
            let p1 = resstComponent.threshold1 / maxRest
            let p2 = resstComponent.threshold2 / maxRest
            let p3 = resstComponent.threshold3 / maxRest
            restBarView.setThreshold(percents: [p1,p2,p3])
        }
        restBarView.updateProgressBar(total: maxRest, current: currentRest, statusName: "")
        
        
        /// 娱乐值
        var currentJoy = 100.0
        var maxJoy = 100.0
        if let joyComponent = entity.getComponent(ofType: JoyComponent.self) {
            currentJoy = joyComponent.current
            maxJoy = joyComponent.total
            let p1 = joyComponent.threshold
            joyBarView.setThreshold(percents: [p1])
        }
        joyBarView.updateProgressBar(total: maxJoy, current: currentJoy, statusName: "")
        
        
        
        aestheticBarView.updateProgressBar(total: 100, current: 35, statusName: "")
        comfortBarView.updateProgressBar(total: 100, current: 60, statusName: "")
        outdoorBarView.updateProgressBar(total: 100, current: 80, statusName: "")
        
        
        let color = UIColor.ml_color(hexValue: 0x4cdffb)
        nutritionBarView.changeFillBarColor(color: color)
        restBarView.changeFillBarColor(color: color)
        joyBarView.changeFillBarColor(color: color)
        aestheticBarView.changeFillBarColor(color: color)
        comfortBarView.changeFillBarColor(color: color)
        outdoorBarView.changeFillBarColor(color: color)
        
    }
    
    
    /// 心情   描述
    func setupRightLayout(_ entity: RMEntity) {
        
        let leftPage = 12.0 * 3.0
        let barHeight = 15.0

        moodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(leftPage)
        }
        
        moodBarView.snp.makeConstraints { make in
            make.top.equalTo(moodLabel.snp.bottom)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
            make.height.equalTo(barHeight)
        }
        
        moodDetailView.snp.makeConstraints { make in
            make.top.equalTo(moodBarView.snp.bottom).offset(24.0)
            make.leading.equalToSuperview().offset(12.0)
            make.trailing.equalToSuperview().offset(-12.0)
            make.bottom.equalToSuperview().offset(-12.0)
        }
        
    
        let color = UIColor.ml_color(hexValue: 0x4cdffb)
        moodBarView.updateProgressBar(total: 100, current: 20, statusName: "")
        moodBarView.changeFillBarColor(color: color)
        
        moodDetailView.backgroundColor = UIColor.cyan
    }
}
