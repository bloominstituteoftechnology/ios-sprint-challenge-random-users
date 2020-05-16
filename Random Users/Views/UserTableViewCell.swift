//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Properties
    var userController: UserController?
    var user: User! {
        didSet {
            updateViews()
        }
    }

    private func updateViews(){
        let imageURL = (user?.picture.thumbnail)!
        userController?.fetchImage(at: imageURL) { (image, error) in
            guard error == nil, let image = image else {
                print("Error fetching image: \(error)")
                return
            }
            self.userImageView.image = image
        }
        nameLabel.text = user?.name.fullName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = #imageLiteral(resourceName: "Lambda_Logo_Full")
        nameLabel.text = ""
    }

}
