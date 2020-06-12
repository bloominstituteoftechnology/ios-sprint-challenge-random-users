//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name.first + " " + user.name.last
    }
}
