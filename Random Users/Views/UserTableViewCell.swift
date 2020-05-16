//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }

    private func updateViews(){
        nameLabel.text = user?.name.fullName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Do something here
    }

}
