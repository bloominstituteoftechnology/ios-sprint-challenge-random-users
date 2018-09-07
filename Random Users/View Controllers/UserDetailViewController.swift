//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let userImage = userImage,
            let userName = userName,
            let userEmail = userEmail,
            let userPhoneNumber = userPhoneNumber else { return }
        
        if let user = user {
            userController?.loadUserImageForDetail(user: user, imageView: userImage)
            userName.text = "\(user.name.first.capitalized) \(user.name.last.capitalized)"
            userEmail.text = user.email
            userPhoneNumber.text = user.phone
        }
    }
    
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var userController: UserController?
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var userPhoneNumber: UILabel!
}
