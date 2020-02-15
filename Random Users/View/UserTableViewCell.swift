//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    //=======================
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fNameLabel: UILabel!
    @IBOutlet weak var lNameLabel: UILabel!
    
    //=======================
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //=======================
    // MARK: - View LifeCycle
    func updateViews() {
        guard let user = user else {return}
        fNameLabel.text = user.fname
        lNameLabel.text = user.lname
    }

}
