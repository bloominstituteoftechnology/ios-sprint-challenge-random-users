//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Wyatt Harrell on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user: Result?
    var photoFetchQueue: OperationQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let user = user else { return }
        let name = "\(user.name.title) \(user.name.first) \(user.name.last)"
        nameLabel.text = name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        
        loadImage(user: user)
    }
    
    private func loadImage(user: Result) {
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user, imageType: .large)
        
        let setImage = BlockOperation {
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: fetchPhotoOperation.imageData!)
            }
        }
        
        setImage.addDependency(fetchPhotoOperation)
        
        photoFetchQueue!.addOperations([fetchPhotoOperation, setImage], waitUntilFinished: false)
    }
    


}
