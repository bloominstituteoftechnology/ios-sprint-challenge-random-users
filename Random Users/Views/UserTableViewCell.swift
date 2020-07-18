//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Rob Vance on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
