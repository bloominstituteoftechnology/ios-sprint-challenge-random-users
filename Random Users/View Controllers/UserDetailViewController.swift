//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var userClient: UserClient?
    var user: User? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    private func updateViews(){
        guard let userClient = userClient,
            let user = user else { return }
        let firstName = user.first.capitalized
        let lastName = user.last.capitalized
        let fullName = "\(firstName) \(lastName)"
        
        nameLabel.text = fullName
        phoneLabel.text = user.phoneNumber
        emailLabel.text = user.emailAddress
        
        userClient.fetchPictures(for: user.largePhoto) { (result) in
            if let result = try? result.get() {
                DispatchQueue.main.async {
                    let image = UIImage(data: result)
                    self.userImage.image = image
                }
            }
        }
    }
    
}
