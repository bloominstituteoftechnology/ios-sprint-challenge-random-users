//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var user: User?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    
    //MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        
        guard let unwrappedUser = user else { return }
        nameLabel.text = "\(unwrappedUser.name.title) \(unwrappedUser.name.first) \(unwrappedUser.name.last)"
        emailLabel.text = unwrappedUser.email
        phoneLabel.text = unwrappedUser.phone
        
    }

}
