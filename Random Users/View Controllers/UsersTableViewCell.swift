//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        userNameLabel.text = "Place Holder"

    }
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
}
