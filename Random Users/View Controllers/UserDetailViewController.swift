//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var user: User?
    var photoFetchQueue: OperationQueue?
    var cache: Cache<String, Data>?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        fetchImage(for: user)
    }
    
    private func fetchImage(for user: User) {
        
        let photoString = user.photo
        
        if let imageData = cache?.retrieveValue(for: photoString),
            let image = UIImage(data: imageData) {
            imageView.image = image
            return
        }
        
        let photoFetchOperation = FetchPhotoOperation(photoString: photoString)
        
        let storeData = BlockOperation {
            if let imageData = photoFetchOperation.imageData {
                self.cache?.cache(value: imageData, for: photoString)
            }
        }
        
        let setImage = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            let image = UIImage(data: data)
            self.imageView.image = image
        }
        
        setImage.addDependency(photoFetchOperation)
        storeData.addDependency(photoFetchOperation)
        
        photoFetchQueue?.addOperations([photoFetchOperation, storeData], waitUntilFinished: true)
        OperationQueue.main.addOperation(setImage)
    }
}
