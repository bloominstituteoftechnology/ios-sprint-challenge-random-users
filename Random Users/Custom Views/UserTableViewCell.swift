//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        guard let user = user else { return }
        let pic = UIImage(data: (user.picture.dataRepresentation))
        thumbnailImageView.image = pic
        userNameLabel.text = user.name
    }
}
