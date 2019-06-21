//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    func updateViews(){
        guard let passedInUser = user else { print("User wasnt passed through"); return }
        nameLabel.text = passedInUser.fullName
    }
    
}
