//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            update()
        }
    }

    private func update() {
        guard let user = user else { return }
        userLabel.text = user.name.fullName
    }
}
