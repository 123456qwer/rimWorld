//
//  MainControllCell.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import UIKit

class MainControllCell: UICollectionViewCell {

    @IBOutlet weak var clickBtn: UIButton!
    
    var clickBlock:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clickBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        // Initialization code
    }

    @IBAction func clickAction(_ sender: Any) {
        clickBlock?()
    }
}
