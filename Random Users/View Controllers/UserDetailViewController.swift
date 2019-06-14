//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // need to load image
        nameLabel.text = user?.name
        phoneLabel.text = user?.phone
        emailLabel.text = user?.email

    }

    // MARK: - Methods
    
    // need a load image function for loading large image
    
    // MARK: - Properties & Outlets
    
    var user: User?
    var userController: UserController?
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

}
