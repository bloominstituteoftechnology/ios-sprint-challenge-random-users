//
//  CustomTableViewCell.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var user: Users? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let user = user else { return }
        userName.text = (user.name.first + user.name.last)
    }
    
}
