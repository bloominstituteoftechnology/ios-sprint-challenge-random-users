//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
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
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Functions
    
    private func updateViews() {
        guard let user = user else { return }
        
        // Get thumbnail image
        
        self.nameLabel.text = "\(user.first) \(user.last)"
    }
    
}
