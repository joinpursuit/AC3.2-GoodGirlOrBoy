//
//  BehaviorTableViewCell.swift
//  GoodGirlOrBoy
//
//  Created by Erica Y Stevens on 1/2/17.
//  Copyright © 2017 Erica Stevens. All rights reserved.
//

import UIKit

class BehaviorTableViewCell: UITableViewCell {
    @IBOutlet weak var behaviorDescriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var behaviorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.behaviorImageView.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
