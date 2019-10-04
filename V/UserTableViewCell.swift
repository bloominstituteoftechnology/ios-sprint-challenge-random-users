//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //Properties
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    
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
            userNameLabel.text = name
        }
    }
}

