//
//  CharacterTabbarView.swift
//  RimWorld
//
//  Created by wu on 2025/5/10.
//

import Foundation
import UIKit

/// (日志、装备、社交、角色、需求、健康)背景
class CharacterTabbarView: UIView {
    
    
    var onTabSelected: ((Tab) -> Void)?
    
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupButtons()
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupButtons() {
        Tab.allCases.forEach { tab in
            if tab == .none { return }
            let button = UIButton(type: .system)
            button.setTitle(tab.rawValue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.setTitleColor(.systemBlue, for: .normal)
            button.tag = buttons.count
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 4.0
            button.layer.borderColor = UIColor.ml_color(hexValue: 0x3A3A3C).cgColor
            button.layer.borderWidth = 1.0
            button.backgroundColor = UIColor.ml_color(hexValue: 0x2c2c2e)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let selectedTab = Tab.allCases[sender.tag]
        onTabSelected?(selectedTab)
    }
}
