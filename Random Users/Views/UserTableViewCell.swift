//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by conner on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            username.text = user.name.displayName
        }
    }
}
