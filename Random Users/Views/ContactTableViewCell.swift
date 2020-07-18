//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var reuseIdentifier = "ContactCell"
    var apiController: APIController?
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
