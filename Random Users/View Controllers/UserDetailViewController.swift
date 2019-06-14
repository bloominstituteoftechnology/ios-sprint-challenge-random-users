//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    var userImage: UIImage?
    var userController: UserController?
    private var cache: Cache<String, UIImage> = Cache()
    private let fetchPhotoQueue = OperationQueue()
    private var fetchedOperations: [String : FetchLargeImageOperation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }

        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        largeImageView.image = userImage
        largeImageView.contentMode = .scaleAspectFit
        
        loadImage(for: user)
    }
    
    private func loadImage(for randomUser: User) {
        
        if let image = cache.value(for: randomUser.email) {
            largeImageView.image = image
        } else {
            let fetchLargePhotoOp = FetchLargeImageOperation(user: randomUser)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchLargePhotoOp.image else { return }
                self.cache.cache(value: image, key: randomUser.email)
            }
            
            let setImageOperation = BlockOperation {
                guard let image = fetchLargePhotoOp.image else { return }
                self.largeImageView.image = image
            }
            
            cacheOperation.addDependency(fetchLargePhotoOp)
            setImageOperation.addDependency(fetchLargePhotoOp)
            
            fetchPhotoQueue.addOperations([fetchLargePhotoOp, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(setImageOperation)
            
            fetchedOperations[randomUser.phone] = fetchLargePhotoOp
        }
    }
    

 // MARK: - IBOutlets
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
}
