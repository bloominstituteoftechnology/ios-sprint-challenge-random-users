//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Joshua Rutkowski on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        if let imageData = imageData {
            userPhoto.image = UIImage(data: imageData)
        }
        nameLabel.text = "Name: \(user.name.first) \(user.name.last)"
        phoneNumberLabel.text = "Phone number: \(user.phone)"
        emailLabel.text = "Email: \(user.email)"
    }

}
