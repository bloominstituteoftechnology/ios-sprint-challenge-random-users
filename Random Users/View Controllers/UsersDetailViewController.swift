//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

// Detail View
class UsersDetailViewController: UIViewController {
    
    // Properties
    var usersController: UsersController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    

    // Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    func updateViews() {
        
    }

}
