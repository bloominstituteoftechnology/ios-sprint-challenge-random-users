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
        guard let user = user else { return }
        load(for: user)
        nameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email

    }

    // MARK: - Methods
    
    func load(for user: User) {
        if let cachedLargeImage = cache.value(for: user.email) {
            largeImageView?.image = cachedLargeImage
        } else {
            let fetchLargeImageOperation = FetchLargePhotoOperation(user: user)
            let cacheOperation = BlockOperation {
                if let data = fetchLargeImageOperation.largeImage {
                    self.cache.cache(value: data, for: user.email)
                }
            }
            let largeImageOperation = BlockOperation {
                guard let largeImage = fetchLargeImageOperation.largeImage else { return }
                self.cache.cache(value: largeImage, for: user.email)
            }
            cacheOperation.addDependency(fetchLargeImageOperation)
            largeImageOperation.addDependency(fetchLargeImageOperation)
            photoFetchQueue.addOperations([fetchLargeImageOperation, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(largeImageOperation)
            fetchedOperations[user.email] = fetchLargeImageOperation
        }
    }
    
    // MARK: - Properties & Outlets
    
    var user: User?
    var userController: UserController?
    let photoFetchQueue = OperationQueue()
    var fetchedOperations: [String : FetchLargePhotoOperation] = [:]
    private let cache = Cache<String, UIImage>()

    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

}
