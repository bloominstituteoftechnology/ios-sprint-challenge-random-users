//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - Properties and IBOutlets -
    
    @IBOutlet var nameLabel: UILabel!
    
    var randomUser: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Methods -
    
    func updateViews() {
        
        nameLabel.text = "\(randomUser?.name.title) \(randomUser?.name.first) \(randomUser?.name.last)"
        
        
    }

}
