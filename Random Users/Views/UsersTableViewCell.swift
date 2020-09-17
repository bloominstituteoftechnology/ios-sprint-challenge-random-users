//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!

    var result: Users? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let result = result else { return }

        usersNameLabel.text = "\(result.name.title)"
        userImageView.image = UIImage(cgImage: result.picture.large as! CGImage)

    }

    var imageData: Data? {
        didSet {
            getImage()
        }
    }

    private func getImage() {
        guard let imageData = imageData else { return }
        userImageView.image = UIImage(data: imageData)
    }
}
