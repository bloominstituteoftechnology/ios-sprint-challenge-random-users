//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private func updateViews() {
        guard let user = user else { fatalError() }
        
        userNameLabel.text = user.fullName
    }
}
