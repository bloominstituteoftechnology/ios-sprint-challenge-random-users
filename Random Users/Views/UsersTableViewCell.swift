//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var users: Users? {
        didSet {
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let users = users else {return}
        
        userNameLabel.text = "\(users.title.capitalized) \(users.firstName.capitalized) \(users.lastName.capitalized)"
        
    //    guard let imageUrl = URL(string: users.thumbnail), let imageData = try? Data(contentsOf: imageUrl) else {return}
        
    //    userImageView.image = UIImage(data: imageData)
    }

    
    override func prepareForReuse() {
        userImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        
        super.prepareForReuse()
    }
   

}
