//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = UIImage(named: "Lambda_Logo_Full")
        userName.text = "Loading"
    }
}
