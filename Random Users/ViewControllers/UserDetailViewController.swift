//
//  UserViewController.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userDetailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var userController: UserController?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    
    func updateViews() {
        let imageURL = (user?.picture.large)!
        userController?.fetchImage(at: imageURL) { (image, error) in
            guard error == nil, let image = image else {
                print("Error fetching image: \(error)")
                return
            }
            self.userDetailImageView.image = image
        }
        nameLabel.text = user?.name.fullName
        phoneNumerLabel.text = user?.phone
        emailLabel.text = user?.email
    }
}
