//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    var user: User?
    var fetchQueue: OperationQueue?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        fetchImage(for: user)
    }
    
    func fetchImage(for user: User) {
        let photoOperation = FetchPhotoOperation(userPhotoRefernce: user)
        let getImage = BlockOperation {
            guard let image = photoOperation.largeImage else { return }
            self.imageView.image = image
        }
        
        getImage.addDependency(photoOperation)
        fetchQueue?.addOperations([photoOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(getImage)
    }

}
