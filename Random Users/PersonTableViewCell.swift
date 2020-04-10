//
//  PersonTableViewCell.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Actions

    // MARK: - Private
    
    private func updateViews() {
        guard let user = user else { return }
        
        nameLabel.text = user.name.fullName
        
        // FIXME: thumbnailImageView
    }
}
