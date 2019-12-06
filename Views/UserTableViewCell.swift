//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Jonalynn Masters on 12/6/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    let selectedView = UIView()
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        userImageView.image = nil
        nameLabel.text = nil
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
    }

}
