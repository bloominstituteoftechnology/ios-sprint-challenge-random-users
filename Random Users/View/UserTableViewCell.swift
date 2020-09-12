//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by ronald huston jr on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
    
        nameLabel.text = "lambda placeholder"
    }


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
}
