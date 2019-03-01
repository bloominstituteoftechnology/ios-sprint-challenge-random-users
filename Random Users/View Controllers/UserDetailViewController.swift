//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let randomUser = user else { return }
    
        nameLabel?.text = randomUser.name
        phoneNumberLabel?.text = randomUser.phone
        emailAddressLabel?.text = randomUser.email
        loadImage(for: randomUser)
    }
    
    private func loadImage(for randomUser: User) {
        
        if let image = cache.value(for: randomUser.phone) {
            imageView.image = image
        } else {
            let fetchLargePhotoOp = FetchLargePhotoOp(user: randomUser)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchLargePhotoOp.image else { return }
                self.cache.cache(value: image, for: randomUser.phone)
            }
            
            let setImageOperation = BlockOperation {
                guard let image = fetchLargePhotoOp.image else { return }
                self.imageView.image = image
            }
            
            cacheOperation.addDependency(fetchLargePhotoOp)
            setImageOperation.addDependency(fetchLargePhotoOp)
            
            fetchPhotoQueue.addOperations([fetchLargePhotoOp, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(setImageOperation)
            
            fetchedOperations[randomUser.phone] = fetchLargePhotoOp
        }
    }

    
   
    // MARK- : Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    

    var userController: UserController?
    private var cache: Cache<String, UIImage> = Cache()
    private let fetchPhotoQueue = OperationQueue()
    private var fetchedOperations: [String : FetchLargePhotoOp] = [:]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    

}
