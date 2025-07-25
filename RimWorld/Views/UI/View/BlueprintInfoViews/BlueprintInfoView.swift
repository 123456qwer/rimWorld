//
//  BlueprintInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/7/25.
//

import Foundation
import UIKit
import Combine

class BlueprintInfoView: UIView {
    
    var cancellables = Set<AnyCancellable>()

    /// 更新各种值
    weak var weakEntity:RMEntity?
    var nextBlock:( ()-> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        RMInfoViewEventBus.shared.publisher().sink {[weak self] event in
            guard let self = self else {return}
            switch event {
            case .updateBlueprint:
                self.updateBlueprintInfo()
            default:
                break
            }

        }.store(in: &cancellables)
    }
    
    func updateBlueprintInfo() {
        guard let entity = weakEntity else { return }
        setData(entity)
    }
    
    func setupUI() {
        addSubview(bgView)
        bgView.addSubview(name)
        bgView.addSubview(nextNodeBtn)
        bgView.addSubview(need)
        setupLayout()
    }
    
    func setupLayout() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
   
      
        let leftPage = 12.0
//        let barHeight = 12.0
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
//            make.height.equalTo(labelHeight)
        }
       
        nextNodeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.height.equalTo(25.0)
        }
        
        need.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(leftPage)
            make.trailing.equalToSuperview().offset(-leftPage)
        }
   
    }
    
    
    func setData(_ entity:RMEntity) {
        weakEntity = entity
        
        guard let blueComponent = entity.getComponent(ofType: BlueprintComponent.self) else {
            return
        }
        
        /// 建筑用料 (默认木头)(key = "\(MaterialType.type.rawValue)" MaterialType)
        var materials: [String:Int] = blueComponent.materials
        /// 已经放入的材料
        var alreadyMaterials: [String: Int] = blueComponent.alreadyMaterials
        
        
        let needMaterialText = NSMutableAttributedString()

        for (material, maxCount) in materials {
            let alreadyCount = alreadyMaterials[material] ?? 0
            let materialType = MaterialType(rawValue: Int(material)!)?.description ?? "不知名"
            
            let typeText = textAction(materialType)
            let countText = "\(typeText): \(alreadyCount)\\\(maxCount)\n"
            
            let color: UIColor = alreadyCount < maxCount ? .red : .green
            let attrString = NSAttributedString(string: countText, attributes: [
                .foregroundColor: color
            ])
            
            needMaterialText.append(attrString)
        }

        
        let blueType = textAction(BlueprintType(rawValue: blueComponent.blueprintType)?.description ?? "")
        need.attributedText = needMaterialText
        name.text = blueType
        
        print(entity)
    }
    
    
    

    
    @objc func nextAction(_ sender: UIButton) {
        nextBlock?()
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
    
    lazy var need:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
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
