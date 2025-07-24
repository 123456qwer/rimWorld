//
//  SaveAreaCell.swift
//  RimWorld
//
//  Created by wu on 2025/7/2.
//

import UIKit

class SaveAreaCell: UITableViewCell {
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var goodsName: UILabel!
    
    var selectBlock:((Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectButton.setImage(UIImage(named: "yes"), for: .selected)
        selectButton.setImage(UIImage(named: "no"), for: .normal)
    }
    
    
    
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectBlock?(sender.isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
