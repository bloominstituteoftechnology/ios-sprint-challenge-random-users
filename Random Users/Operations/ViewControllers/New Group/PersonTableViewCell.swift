//
//  PersonTableViewCell.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

   var indexPath = IndexPath()

    var user: User? {
        didSet {
            updateViews()
        }
    }


    // MARK: - IBOutlets
    
    @IBOutlet var userPicture: UIImageView!
    @IBOutlet var userName: UILabel!


    // MARK: - Functions
    
    func updateViews() {

        userName.text = user?.name.fullName
    }
}
