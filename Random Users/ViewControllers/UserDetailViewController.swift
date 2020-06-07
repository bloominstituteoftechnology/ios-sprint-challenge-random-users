//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Enzo Jimenez-Soto on 6/7/20.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Private Methods

    private func updateViews() {
        if isViewLoaded {
            nameTextField.text = user.name.full
            phoneTextField.text = user.phone
            emailTextField.text = user.email
        }
    }
}
