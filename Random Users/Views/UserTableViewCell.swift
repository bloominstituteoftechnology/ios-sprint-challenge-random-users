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
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        

        userImageView.image = UIImage(named: user.picture.thumbnail)
//        if let data = try? Data(contentsOf: user.picture.thumbnail) {
//            userImageView.image = UIImage(data: data)
//        }
        userNameLabel.text = user.name.title + user.name.first + user.name.last
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
