//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    //MARK: Properties
    var randomUsersController = RandomUsersController()
    var user: UserResults? {
        didSet {
            self.updateViews()
        }
    }
    
    private let cache = Cache<String, Data>()
    
    // MARK: - Functions
    func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
        
        //check the cache before calling function
        if let cacheData = cache.value(for: user.email),
            let image = UIImage(data: cacheData) {
            userImageView.image = image
            return
        }
        
        getImage(with: user)
    }
    
    func getImage(with user: UserResults) {
        let imagePath = user.picture.thumbnail
        randomUsersController.downloadUserImage(path: imagePath) { (result) in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            
            // Save it to the cache
            self.cache.cache(value: imageString, for: user.email)
            
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
    }

}
