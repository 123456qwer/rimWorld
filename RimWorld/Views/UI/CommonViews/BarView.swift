//
//  SliderView.swift
//  RimWorld
//
//  Created by wu on 2025/5/7.
//

import Foundation
import UIKit

/// 条状状态
class BarView: UIView {
    
    lazy var progressBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var progressBarFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    func changeFillBarColor(color:UIColor) {
        progressBarFillView.backgroundColor = color
    }
    
    func setupUI(){
        addSubview(progressBarBackgroundView)
        addSubview(progressBarFillView)
        addSubview(status)
        progressBarBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        status.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressBarFillView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(CGFloat(1) / CGFloat(1))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更新进度条
    func updateProgressBar(total:Double, current:Double,statusName:String){
        progressBarFillView.snp.removeConstraints()
        progressBarFillView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(CGFloat(current) / CGFloat(total))
        }
//        let progress = CGFloat(current) / CGFloat(total)
//        let newWidth = progressBarBackgroundView.bounds.width * progress
//        UIView.animate(withDuration: 0.3) {
//            self.progressBarFillView.frame.size.width = newWidth
//        }
        status.text = statusName
    }
}
