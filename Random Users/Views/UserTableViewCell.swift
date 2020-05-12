//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
     // MARK: - Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let user = user else { return }
        self.userName.text = user.name.title
    }
    
}
