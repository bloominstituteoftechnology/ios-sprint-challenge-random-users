//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    //MARK:- Properties
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
 
    var user: User?
    
  
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "User Detail"
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = user {
            userNameLabel.text = user.name
            userPhoneLabel.text = user.phoneNumber
            userEmailLabel.text = user.email
            userImageView.load(url: user.largeImage)
        }
    }
    
    


}
