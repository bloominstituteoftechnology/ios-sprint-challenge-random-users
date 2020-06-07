//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Enzo Jimenez-Soto on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    // MARK: - Properties

    var user: User! {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private Methods
    
    private func updateViews() {
        nameLabel.text = user.name.full
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        nameLabel.text = nil
    }

}
