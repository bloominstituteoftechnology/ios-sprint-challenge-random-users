//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        
        guard let user = user, let userController = userController else { return }
        
        let imageFetch = ImageFetchOperation(userController: userController, url: user.largePicture)
        guard let image = imageFetch.image else { return }
        
        userImageView.image = image
        
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
//    private func fetchDetails() {
//        guard let user = user, let userController = userController else { return }
//        userController.fetchUser(for: user) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let user):
//                self.updateViews(with: user)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }

}
