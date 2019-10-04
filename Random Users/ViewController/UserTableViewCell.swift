//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
//    override func prepareForReuse() {
//        DispatchQueue.main.async {
//            
//        }
//        
//        super.prepareForReuse()
//    }
    
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.title + " " + user.first + " " + user.last
    }

}
