//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    //Properties
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
   
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        if let user = user {
            let title: String = user.name["title"]!
            let firstName: String = user.name["first"]!
            let lastName: String = user.name["last"]!
            let name: String = "\(title) \(firstName) \(lastName)"
            nameLabel.text = name
        }
    }

}
