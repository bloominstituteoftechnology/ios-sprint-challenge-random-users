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

    }

    // MARK: - Methods
    
    // MARK: - Properties & Outlets
    
    var user: User?
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

}
