//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userPhoneNumberLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    // MARK: - Properties
    var randomUser: UserResults?
    var randomUsersController = RandomUsersController()
    private let cache = Cache<String, Data>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard let randomUser = randomUser else { return }
        userNameLabel.text = "\(randomUser.name.title) \(randomUser.name.first) \(randomUser.name.last)"
        userPhoneNumberLabel.text = randomUser.phone
        userEmailLabel.text = randomUser.email
        
        //check the cache before calling function
        if let cacheData = cache.value(for: randomUser.email),
            let image = UIImage(data: cacheData) {
            userImageView.image = image
            return
        }
        // get the image
        getImage(with: randomUser)
        
    }
    
    func getImage(with user: UserResults) {
        let imagePath = user.picture.large
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
