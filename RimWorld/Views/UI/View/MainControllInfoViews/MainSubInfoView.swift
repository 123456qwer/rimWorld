//
//  MainSubInfoView.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import UIKit

class MainSubInfoView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let collectionView: UICollectionView
    var gameContext: RMGameContext?

    let height = 44.0
    
    var key:ArchitectCategory = .command
    
 
   
    
    private let itemsClick: [ArchitectCategory:[ActionType]] = [
        
        .command:[
        .cancel,
        .deconstruct,
        .mine,
        .chopWood,
        .harvest,
        .hunt,
        .slaughter,
        .tame
      ],
        
            .zone:[.cancel,
                   .deconstruct,
                   .storageArea,
                   .garbageArea,
                   .plantingArea,
                   .removeArea,
                   .addResidentialArea,
                   .removeResidentialArea,
                   .addActivityArea,
                   .removeActivityArea],
                                                                
        
            .structure:[.cancel,
                        .deconstruct,
                        .wall],
                                                     
            .production:[.cancel,
                         .deconstruct,
                         .fueledStove,
                         .electricStove],
                                                     
            .furniture:[],
                                                     
            .power:[],
                                                     
            .security:[],
                                                     
            .misc:[],
                                                     
            .floor:[],
                                                      
            .joy:[],
                                                     
            .culture:[],
                                                     
            .biotech:[],
    ]




    override init(frame: CGRect) {

        
        // 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1   // 行间距
        layout.minimumInteritemSpacing = 5 // 列间距
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
    
        super.init(frame: frame)
        

        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(UINib.init(nibName: "MainSubInfoCell", bundle: nil), forCellWithReuseIdentifier: "MainSubInfoCell")
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0.0)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadSubDataWithKey(key:ArchitectCategory) {
        self.key = key
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr = itemsClick[key]
        return arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainSubInfoCell", for: indexPath) as! MainSubInfoCell
        
        let arr = itemsClick[key]!


        // 样式
        cell.contentView.backgroundColor = UIColor.btnBgColor()

        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1.0
        cell.nameLabel.text = textAction(arr[indexPath.row].rawValue)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 44.0
        return CGSize(width: width, height: height)
    }
    
    /// 选中操作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let items = itemsClick[key]!
        
        let type = items[indexPath.row]
        gameContext?.currentMode = type
        
        
        RMInfoViewEventBus.shared.requestReloadBottomView(actionType: type)
        RMEventBus.shared.requestClickEmpty()
    }
}
