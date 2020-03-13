//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  
    var user: Result? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        if let user = user {
            let firstName: String = user.name["first"]!.capitalized
            let lastName: String = user.name["last"]!.capitalized
                       
            let name: String = "\(firstName) \(lastName)"
            nameLabel.text = name
        }
    }
}
