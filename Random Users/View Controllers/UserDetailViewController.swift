//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var users: Users? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        
        guard isViewLoaded else {
            return
        }
        
        guard let users = users else {return}
        
        userNameLabel.text = "\(users.title.capitalized) \(users.firstName.capitalized) \(users.lastName.capitalized)"
        
        emailLabel.text = users.email
        phoneNumberLabel.text = users.phone
        
        guard let imageUrl = URL(string: users.large), let imageData = try? Data(contentsOf: imageUrl) else {return}
        let image = UIImage(data: imageData)
        userImageView.image = image
        userImageView.layer.cornerRadius = 50
        userImageView.layer.masksToBounds = true
        
        
    }
    

}
