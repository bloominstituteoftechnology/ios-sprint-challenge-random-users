//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        
        randomImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        nameLabel.text = "Lambda Placeholder"
    }
    
    @IBOutlet weak var randomImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
}
