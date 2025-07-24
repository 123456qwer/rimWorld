//
//  LogCell.swift
//  RimWorld
//
//  Created by wu on 2025/5/28.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var logImageView: UIImageView!
    @IBOutlet weak var logContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black.withAlphaComponent(0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
