//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

     override func prepareForReuse() {
           super.prepareForReuse()
        
           userImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
           nameLabel.text = "Lambda Placeholder"
       }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
}
