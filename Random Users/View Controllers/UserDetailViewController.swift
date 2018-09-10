//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    func updateViews(){
        guard let user = user else {return}
        nameLabel.text = user.fullName
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    var user: User?{
        didSet{
            updateViews()
        }
    }
}
