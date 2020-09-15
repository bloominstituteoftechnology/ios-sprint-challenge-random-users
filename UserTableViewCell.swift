//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userThumbnail: UIImageView!
    
    private func updateViews() {
        
        guard let user = user else {return}
        userLabel.text = user.name
//
//        let url = URL(string: "\(user.thumbnail)")!
//        if let data = try? Data(contentsOf: url) {
//
//            userThumbnail.image = UIImage(data: data)
//        }
    }
}
