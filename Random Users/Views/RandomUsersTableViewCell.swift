//
//  RandomUsersTableViewCell.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewCell: UITableViewCell {
    
    var user: Users? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    func updateViews() {
        guard let user = user else { return }
        userName.text = "\(user.name.first) \(user.name.last)"
    }
}
