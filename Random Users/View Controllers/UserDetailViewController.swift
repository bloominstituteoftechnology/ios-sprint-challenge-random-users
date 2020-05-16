//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { fatalError() }
        
        nameLabel.text = user.fullName
        phoneLabel.text = user.phone
        emailLabel.text = user.email
                
        guard let imageData = try? Data(contentsOf: user.picture.large) else { return }
        imageView.image = UIImage(data: imageData)
    }
}
