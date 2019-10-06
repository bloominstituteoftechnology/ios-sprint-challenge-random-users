//
//  PersonTableViewCell.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    
    
    override func prepareForReuse() {
         super.prepareForReuse()
        personImageView.image = #imageLiteral(resourceName: "iconfinder_Picture1_3289576")
       
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    
    
}
