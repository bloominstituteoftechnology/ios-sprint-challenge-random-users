//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    var fullName: String {
        return "\(user!.name.title) \(user!.name.first) \(user!.name.last)"
    }

    @IBOutlet weak var userThumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateView() {
        nameLabel.text = fullName
        getUserImage()
    }
    
    func getUserImage() {
        guard let image = user?.picture.thumbnail else { return }
        if let url = URL(string: image) {
            do {
                let data = try Data(contentsOf: url)
                self.userThumbnailImage.image = UIImage(data: data)
            } catch {
                NSLog("Error getting user Thumbnail image")
            }
        }
    }
    
}
