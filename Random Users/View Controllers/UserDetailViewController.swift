//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        userImageView.image = UIImage(data: (user?.picture.dataRepresentation)!)
        
        nameLabel.text = user?.name
        phoneLabel.text = user?.phone
        emailLabel.text = user?.email
    }
}
