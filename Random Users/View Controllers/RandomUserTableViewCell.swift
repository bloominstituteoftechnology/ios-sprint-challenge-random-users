//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

    // Variables & Constants
    var randomUser: RandomUser? {
        didSet {
            updateViews()
        }
    }
    
    // Outlets and Actions
    @IBOutlet weak var randomUsersLabel: UILabel!
    @IBOutlet weak var randomUsersImageView: UIImageView!
    
    // Functions
    func updateViews() {
        if let randomUser = randomUser {
            randomUsersLabel.text = "\(randomUser.title.capitalized). \(randomUser.first.capitalized) \(randomUser.last.capitalized)"
            let imageData = try! Data(contentsOf: randomUser.picture)
            randomUsersImageView.image = UIImage(data: imageData)
        }
    }
}
