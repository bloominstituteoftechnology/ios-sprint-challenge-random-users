//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - Properties

    var user: User! {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var phoneTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    
    // MARK: - View Controller Lifecycle
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    // MARK: - Private Methods

    private func updateViews() {
        nameTextField.text = user.name
        phoneTextField.text = user.phone
        emailTextField.text = user.email
        
//        let imageURL = user.picture.large
//        let image = fetchImage(at: imageURL)
//        imageView.image = image
    }
}
