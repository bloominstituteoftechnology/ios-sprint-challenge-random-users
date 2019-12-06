//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        if let imageData = imageData {
            pictureImageView.image = UIImage(data: imageData)
        }
        nameLabel.text = "\(user.name.first) \(user.name.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
}
