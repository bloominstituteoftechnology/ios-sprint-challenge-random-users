//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
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
        
//        let imageURL = user.picture.large
//        let image = fetchImage(at: imageURL)
//        thumbnailImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        nameLabel.text = nil
    }

}
