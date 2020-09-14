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
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
