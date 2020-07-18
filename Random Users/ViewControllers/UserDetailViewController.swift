//
//  UserViewController.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userDetailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    
    func updateViews() {
        guard let user = user else { return }
        let fetchPhotoOp = FetchPhotoOperation(user: user, imageSize: .thumbnail)
        fetchPhotoOp.fetchImage(from: user.picture.large) { (data, error) in
            guard error == nil else {
                NSLog("Error fetching image: \(error)")
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.userDetailImageView.image = UIImage(data: data)
            }
        }

        nameLabel.text = user.name.fullName
        phoneNumerLabel.text = user.phone
        emailLabel.text = user.email
        
    }
}
