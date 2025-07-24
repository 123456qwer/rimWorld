//
//  operationView.swift
//  RimWorld
//
//  Created by wu on 2025/6/3.
//

import Foundation
import UIKit




class OperationView: UIView {
    
    var labelHeight = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDayChanged),
            name: .RMGameTimeDayChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleHourChanged),
            name: .RMGameTimeHourChange,
            object: nil
        )
    }
    
    private func setupUI() {
        
        ml_addSubviews([weatherLabel,
                        timeLabel,
                        hourLabel,
                        gameSpeedControlView])
        gameSpeedControlView.ml_addSubviews([pauseBtn,startBtn,speed2xBtn,speed3xBtn])
        setupLayout()
    }
    
    private func setupLayout() {
        
        let btnSize = 25.0
        let page = (120 - 4 * btnSize) / 3.0
        
        gameSpeedControlView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(btnSize)
            make.width.equalTo(120.0)
        }
        pauseBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(btnSize)
        }
        startBtn.snp.makeConstraints { make in
            make.left.equalTo(pauseBtn.snp.right).offset(page)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(btnSize)
        }
        speed2xBtn.snp.makeConstraints { make in
            make.left.equalTo(startBtn.snp.right).offset(page)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(btnSize)
        }
        speed3xBtn.snp.makeConstraints { make in
            make.left.equalTo(speed2xBtn.snp.right).offset(page)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(btnSize)
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gameSpeedControlView.snp.top).offset(-5)
            make.trailing.equalToSuperview()
            make.height.equalTo(labelHeight)
        }
        hourLabel.snp.makeConstraints { make in
            make.bottom.equalTo(timeLabel.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(labelHeight)
        }
        weatherLabel.snp.makeConstraints { make in
            make.bottom.equalTo(hourLabel.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(labelHeight)
        }
       
        let time = DBManager.shared.getTime()
        timeLabel.text = time.formatRimWorldTime()
        hourLabel.text = time.hourTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDayChanged(_ notification:NSNotification) {
        print(notification)
        let time = notification.object as! RMGameTime
        timeLabel.text = time.formatRimWorldTime()
    }
    @objc func handleHourChanged(_ notification:NSNotification) {

        let time = notification.object as! RMGameTime
        hourLabel.text = time.hourTime()
   
    }
    /// 暂停
    @objc func pauseAction(_ sender:UIButton) {
        clearBtnBgColor()
        setSelectBtn(sender)
        RMEventBus.shared.publish(.pause)
    }
    /// 开始
    @objc func startAction(_ sender:UIButton) {
        clearBtnBgColor()
        setSelectBtn(sender)
        RMEventBus.shared.publish(.speed1)
    }
    /// 二倍速
    @objc func speed2xAction(_ sender:UIButton) {
        clearBtnBgColor()
        setSelectBtn(sender)
        RMEventBus.shared.publish(.speed2)
    }
    /// 三倍速
    @objc func speed3xAction(_ sender:UIButton) {
        clearBtnBgColor()
        setSelectBtn(sender)
        RMEventBus.shared.publish(.speed3)
    }
    
    
    private func setSelectBtn(_ sender:UIButton){
        sender.backgroundColor = .white.withAlphaComponent(0.7)
    }
    
    private func clearBtnBgColor(){
        pauseBtn.backgroundColor = .clear
        startBtn.backgroundColor = .clear
        speed2xBtn.backgroundColor = .clear
        speed3xBtn.backgroundColor = .clear
    }
    
    /// 年 季节 天
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    /// 时
    lazy var hourLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    /// 天气
    lazy var weatherLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.textColor = .white
        label.text = textAction("晴")
        return label
    }()
    
    /// 暂停、开始、加速2、加速3背景
    lazy var gameSpeedControlView:UIView = {
        let view = UIView()
//        view.backgroundColor = .orange
        return view
    }()
    lazy var pauseBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "pause"), for: .normal)
        btn.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return btn
    }()
    lazy var startBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "start"), for: .normal)
        btn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        setSelectBtn(btn)
        return btn
    }()
    lazy var speed2xBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "speed1"), for: .normal)
        btn.addTarget(self, action: #selector(speed2xAction), for: .touchUpInside)
        return btn
    }()
    lazy var speed3xBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "speed2"), for: .normal)
        btn.addTarget(self, action: #selector(speed3xAction), for: .touchUpInside)
        return btn
    }()
    
}
