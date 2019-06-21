//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {
    
    private func updateViews() {
        if let user = user {
            cellNameLabel.text = user.name
            let url = user.smallImageURL
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                cellImageView.image = image
            }
        }
    }
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
}
