//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateView()
        }
    }

    @IBOutlet weak var userThumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateView() {
        nameLabel.text = user?.name.fullName
        getUserImage()
    }
    
    func getUserImage() {
        
    }
    
}
