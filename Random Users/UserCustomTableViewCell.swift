//
//  UserCustomTableViewCell.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageInCell: UIImageView!
    @IBOutlet weak var userNameInCell: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
