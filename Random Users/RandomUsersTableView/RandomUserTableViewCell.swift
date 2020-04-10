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
    
    var user: User? { didSet { updateViews() }}
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Private
    
    func updateViews() {
        guard let user = user else { return }
        self.nameLabel.text = user.name.title + " " + user.name.first + " " + user.name.last
    }
    
    override func prepareForReuse() {
        user = nil
    }
}
