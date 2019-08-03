//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Seschwan on 8/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
