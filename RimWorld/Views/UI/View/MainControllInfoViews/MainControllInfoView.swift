//
//  ControllInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import UIKit

class MainControllInfoView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let collectionView: UICollectionView
    var subInfoView: MainSubInfoView?
    var ecsManager: ECSManager?

    var isSelect: Int = 0
    let height = 30.0
    let page   = 1.0
    
    // 测试数据
    private let items = [
        "命令", "区域",
        "结构", "生产",
        "家具", "电力",
        "防卫", "杂项",
        "地板", "娱乐",
        "文化", "生物技术"
    ]
    
    /// 子类型
    let buildCategories: [ArchitectCategory] = ArchitectCategory.allCases.map { $0 }

    
    override init(frame: CGRect) {
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = page   // 行间距
        layout.minimumInteritemSpacing = 1 // 列间距
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
    
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.BgColor()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0.0)
            make.width.equalToSuperview()
            make.height.equalTo(6 * height + 7 * page)
        }
        
        collectionView.register(UINib.init(nibName: "MainControllCell", bundle: nil), forCellWithReuseIdentifier: "MainControllCell")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainControllCell", for: indexPath) as! MainControllCell
        
        cell.clickBtn.setTitle(items[indexPath.item], for: .normal)
        // 样式
        cell.contentView.backgroundColor = UIColor.btnBgColor()
        
        if isSelect == indexPath.row {
            cell.contentView.backgroundColor = UIColor.ml_color(hexValue: 0x3A82F6)
            cell.clickBtn.setTitleColor(.white, for: .normal)
        }else{
            cell.contentView.backgroundColor = UIColor.btnBgColor()
            cell.clickBtn.setTitleColor(.white, for: .normal)
        }
        
        /// 重置选中状态
        cell.clickBlock = {[weak self] in
            guard let self = self else {return}
            self.isSelect = indexPath.row
            self.collectionView.reloadData()
            self.subInfoView?.reloadSubDataWithKey(key: buildCategories[indexPath.row])
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 1 // 列间距
        let width = (collectionView.bounds.width - CGFloat(totalSpacing)) / 2
        return CGSize(width: width, height: height)
    }
}

