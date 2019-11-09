//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        
        let fullName = "\(user.title + user.first + user.last)"
        if let data = try? Data(contentsOf: user.thumbnail) {
            userImageView.image = UIImage(data: data)
        }
        userNameLabel.text = fullName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
