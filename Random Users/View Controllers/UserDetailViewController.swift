//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Methods
    
    func loadLargeImage(for user: User) {
        if let cachedLargeImage = cache.value(for: user.email) {
            self.largeImageView.image = cachedLargeImage
            return
        }
        let fetchLargeImageOperation = FetchLargePhotoOperation(user: user)
        let cacheOperation = BlockOperation {
            if let data = fetchLargeImageOperation.largeImage {
                self.cache.cache(value: data, for: user.email)
            }
        }
        let largeImageOperation = BlockOperation {
            if self.cache.value(for: user.email) != nil,
                let data = self.cache.value(for: user.email) {
                self.largeImageView.image = data
            } else if let largeImage = fetchLargeImageOperation.largeImage {
                self.largeImageView.image = largeImage
            }
        }
        cacheOperation.addDependency(fetchLargeImageOperation)
        largeImageOperation.addDependency(fetchLargeImageOperation)
        photoFetchQueue.addOperations([fetchLargeImageOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(largeImageOperation)
        fetchedOperations[user.email] = fetchLargeImageOperation
    }
    
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        loadLargeImage(for: user)
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
    // MARK: - Properties & Outlets
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    var userController: UserController?
    let photoFetchQueue = OperationQueue()
    var fetchedOperations: [String : FetchLargePhotoOperation] = [:]
    private let cache = Cache<String, UIImage>()
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
}
