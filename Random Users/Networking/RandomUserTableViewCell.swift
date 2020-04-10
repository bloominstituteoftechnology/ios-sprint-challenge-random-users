//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var user: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private
    
    override func prepareForReuse() {
        user = nil
    }
}
