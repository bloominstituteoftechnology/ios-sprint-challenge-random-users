//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    var user: UserResults? {
        didSet {
            self.updateViews()
        }
    }
    
    func updateViews() {
        guard let user = user else { return }
        
        userNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBAction
    

}
