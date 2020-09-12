//
//  DetailViewController.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    // MARK: - Properties
    
    var user: User?
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            self.updateViews(with: user)
        }
    }

    // MARK: - Functions
    
    private func updateViews(with user: User) {
        
        // get large image
        
        nameLabel.text = "\(user.first) \(user.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }

}
