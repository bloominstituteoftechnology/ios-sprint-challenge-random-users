//
//  UserTVCell.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTVCell: UITableViewCell {

       

    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var personNameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateCell()
        }
    }
    var imageData: Data? {
        didSet {
            loadImage()
        }
    }
    
    private func updateCell() {
        guard let user = user else { return }
        personNameLabel.text = user.name.first
    }
    
    private func loadImage() {
        guard let imageData = imageData else { return }
        userImageView.image = UIImage(data: imageData)
    }

}
