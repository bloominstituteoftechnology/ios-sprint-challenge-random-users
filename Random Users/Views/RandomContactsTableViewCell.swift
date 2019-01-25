//
//  RandomContactsTableViewCell.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomContactsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    var contact: RandomUser?
}
