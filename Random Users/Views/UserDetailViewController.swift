//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Outlets
    @IBOutlet var largeImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    // MARK: - Methods
    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        phoneNumberLabel.text = user.phone
        emailLabel.text = user.email
    }
}
