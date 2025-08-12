//
//  MainSubInfoCell.swift
//  RimWorld
//
//  Created by wu on 2025/8/11.
//

import UIKit

class MainSubInfoCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bgImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.systemFont(ofSize: 12.0)
        nameLabel.numberOfLines = 0
        // Initialization code
    }

}
