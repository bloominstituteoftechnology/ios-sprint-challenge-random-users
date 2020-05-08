//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = user.name.fullName
}
}
