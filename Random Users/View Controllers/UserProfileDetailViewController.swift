//
//  UserProfileDetailViewController.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit
class UserProfileDetailViewController: UIViewController {
    // MARK: - Properties
    
    var user: User?
    var userImage: Data?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        
        userNameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        if let picture = userImage {
            imageView?.image = UIImage(data: picture)
        }
    }
}
