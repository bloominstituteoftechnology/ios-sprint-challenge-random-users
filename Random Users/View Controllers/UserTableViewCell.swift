//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var userController: UserController?
    var friend: Friend? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userThumbnailImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateViews() {
        guard let friend = friend else { return }
        userController?.fetchImage(at: friend.thumbnail, completion: { (image, error) in
            if let image = image {
                DispatchQueue.main.async {
                    self.userThumbnailImage.image = image
                }
            }
        })
        
        userNameLabel.text = "\(friend.title) \(friend.first) \(friend.last)"
    }

}
