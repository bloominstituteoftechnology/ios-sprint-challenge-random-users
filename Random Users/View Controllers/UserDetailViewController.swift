//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure we have a user
        guard let user = user else { return }
        
        // Display the data
        userNameLabel.text = user.name
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        
        
    }
    
    
    

    // MARK: - Properties
    var user: RandomUser?
    let fetchRandomUserQueue = OperationQueue()
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}
