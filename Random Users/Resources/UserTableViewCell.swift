//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
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
    
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    

}
