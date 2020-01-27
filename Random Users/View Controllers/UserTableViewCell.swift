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
    var cache: Cache<String, UIImage>?
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
        userNameLabel.text = "\(friend.title) \(friend.first) \(friend.last)"
        
        guard let cache = cache else { return }
        guard cache.value(for: friend.phone) == nil else {
            guard let cachedImage = cache.value(for: friend.phone) else { return }
            userThumbnailImage.image = cachedImage
            return
        }
            
        userController?.fetchImage(at: friend.thumbnail) { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.userThumbnailImage.image = image
                }
            }
        }
        }
    

}
