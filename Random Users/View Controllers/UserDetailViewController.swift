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
    
    var userQueue = OperationQueue()
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        guard let user = user, let userController = userController else { return }
        
        let imageFetch = ImageFetchOperation(userController: userController, url: user.largePicture)
        let completionOperation = BlockOperation {
            guard let image = imageFetch.image else { return }
            self.userImageView.image = image
            self.nameLabel.text = user.name
            self.phoneLabel.text = user.phone
            self.emailLabel.text = user.email
        }
        
        completionOperation.addDependency(imageFetch)
        userQueue.addOperation(imageFetch)
        OperationQueue.main.addOperation(completionOperation)
    }
}
