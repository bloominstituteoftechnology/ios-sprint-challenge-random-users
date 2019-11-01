//
//  RandomUsersTableViewCell.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUsersTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var users: RandomUsers? {
        didSet {
            updateViews()
        }
    }
    var client: RandomUsersClient?
    
    // MARK: - Outlets
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    

    func updateViews() {
        guard let users = users else { return }
        
        userName.text = users.name.first
        client?.fetchImage(at: (users.image.thumbnail), completion: { (image) in
            DispatchQueue.main.async {
                self.userThumbnail.image = image
            }
        })
    }

    
    
}
