//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Kat Milton on 8/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2.6
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.borderColor = AppearanceHelper.purpleColor.withAlphaComponent(0.7).cgColor
        
        if let user = user {
            let firstName: String = user.name["first"]!.capitalized
            let lastName: String = user.name["last"]!.capitalized
            let name: String = "\(firstName) \(lastName)"
           
            
            userNameLabel.text = name
        }
    }


}


