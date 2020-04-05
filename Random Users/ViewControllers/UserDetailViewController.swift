//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Gerardo Hernandez on 4/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    
//MARK: -  Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var phoneTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UILabel!

//MARK: - Properties
    var user: User! {
        didSet {
            updateViews()
        }
    }
    //MARK: - View LIfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    

    private func updateViews() {
        if isViewLoaded {
            nameTextField.text = user.name.fullName
            phoneTextLabel.text = user.phone
            emailTextField.text = user.email
        }
    }

}
