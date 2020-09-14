//
//  UserViewController.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var userLargeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else {return}
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
 

}
