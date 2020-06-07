//
//  UserViewCell.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserViewCell: UITableViewCell {
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    var thumbnail: UIImage? {
        didSet {
            updateThumbnail()
        }
    }
    
    private func updateView() {
        if let user = user {
            userNameLabel.text = user.getName()
        }
    }
    
    private func updateThumbnail() {
        if let thumbnail = thumbnail {
            userImageView.image = thumbnail
        }
    }
}
