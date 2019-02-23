//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        
        if let user = user {
            
            nameLabel.text = user.fullName
            
        }
        
    }
    
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    

}
