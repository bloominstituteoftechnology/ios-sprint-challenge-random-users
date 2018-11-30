//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Sean Hendrix on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    // MARK:- View update method
    private func updateViews() {
        guard let user = user else { return }
        
        // UI adjustments
        userPhotoImageView.image = nil
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2
        userPhotoImageView.layer.masksToBounds = true
        userPhotoImageView.alpha = 0
        
        // Show user's name
        nameLabel.text = user.name.formatted.3
    }
    
    private func updateImageView() {
        guard let userImage = userImage else { return }
        
        userPhotoImageView.image = userImage
        
        UIView.animate(withDuration: 0.07) {
            self.userPhotoImageView.alpha = 1
        }
    }
    
    // MARK:- Properties & types
    var user: User? { didSet { updateViews() }}
    var userImage: UIImage? { didSet { updateImageView() }}
    
    // MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
}
