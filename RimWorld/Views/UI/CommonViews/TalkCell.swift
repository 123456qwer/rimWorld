//
//  TalkCell.swift
//  RimWorld
//
//  Created by wu on 2025/5/28.
//

import UIKit

class TalkCell: UITableViewCell {

    @IBOutlet weak var talkContent: UILabel!
    @IBOutlet weak var talkImageView: UIImageView!
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
