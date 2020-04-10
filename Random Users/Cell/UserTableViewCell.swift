//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Lydia Zhang on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func prepareForReuse() {
        userImage.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        userName.text = "User Name"
        super.prepareForReuse()
    }
    
}
