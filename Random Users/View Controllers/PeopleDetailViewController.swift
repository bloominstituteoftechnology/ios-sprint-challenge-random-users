//
//  PeopleDetailViewController.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController {
    
    var userController: UserController?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        
//        self.imageView = user.pictures
        self.nameLabel?.text = "Name: \(user.name.capitalized)"
        self.phoneLabel?.text = "Phone: \(user.phone)"
        self.emailLabel?.text = "Email: \(user.email)"
    }

}
