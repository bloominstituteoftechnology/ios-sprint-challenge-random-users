//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var userThumbImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    func updateViews() {
        
    }
}
