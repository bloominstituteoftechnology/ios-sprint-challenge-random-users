//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let user = user else { return }
        
        storedFetchedOperations[user.phone]?.cancel()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        
        fullNameLabel?.text = user.name
        phoneLabel?.text = user.phone
        emailLabel?.text = user.email
        loadedImage(for: user)
    
    }
    
    private func loadedImage(for user: User) {
        
        if let image = largeImageCache.value(for: user.phone) {
            
           largeImageView.image = image
        } else {
            
            let fetchLargePhotoOperation = FetchLargePhotoOperation(user: user)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchLargePhotoOperation.image else { return }
                
                self.largeImageCache.cache(value: image, for: user.phone)
            }
            
            let setImageOperation = BlockOperation {
                guard let image = fetchLargePhotoOperation.image else { return }
                
                self.largeImageView.image = image
            }
            
            cacheOperation.addDependency(fetchLargePhotoOperation)
            setImageOperation.addDependency(fetchLargePhotoOperation)
            
            photoFetchQueue.addOperations([fetchLargePhotoOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(setImageOperation)
            
            storedFetchedOperations[user.phone] = fetchLargePhotoOperation
        }
    }

    // MARK: - Properties
    
    private var storedFetchedOperations: [String : FetchLargePhotoOperation] = [:]
    
    private let photoFetchQueue = OperationQueue()
    
    private var largeImageCache: Cache<String, UIImage> = Cache()
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var userController: ModelClient?
    
    @IBOutlet var largeImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
}
