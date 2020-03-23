//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Joshua Rutkowski on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
    }

}
