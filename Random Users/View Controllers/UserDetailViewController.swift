//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User?

    @IBOutlet weak var userDetailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    func updateViews() {
        guard let user = user else { return }
        
        let imageURL = user.picture.largeImageURL
        if let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData) {
            userDetailImageView.image = image
        }
        let fullName = "\(user.name.firstName) \(user.name.lastName)"
        nameLabel.text = fullName
        emailLabel.text = user.email
        phoneNumberLabel.text = user.cellPhoneNumber
    }
}
