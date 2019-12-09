//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = ("\(user.name.first) \(user.name.last)")
        
    }


}
