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
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Methods -
    
    func updateViews() {
        guard let unwrappedUser = user else { return }
        
        DispatchQueue.main.async {
            self.nameLabel.text = "\(unwrappedUser.name.title) \(unwrappedUser.name.first) \(unwrappedUser.name.last)"
        }
        
    }

} //End of class
