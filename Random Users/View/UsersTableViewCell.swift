//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Gerardo Hernandez on 4/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userThumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var user: User! {
        didSet{
            updateViews()
        }
    }
    

    private func updateViews() {
        nameLabel.text = user.name.fullName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userThumbnailImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        nameLabel.text = nil
    }
    

}
