//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
