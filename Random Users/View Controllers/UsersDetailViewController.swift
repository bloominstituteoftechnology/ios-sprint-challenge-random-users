//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

// Detail View
class UsersDetailViewController: UIViewController {
    
    // Properties
    var userImage: UIImage?
    var usersController: UsersController?
    private var cache: Cache<String, UIImage> = Cache()
    private let operationQueue = OperationQueue()
    private var fetchOp: [String : FetchDetailViewImageOperation] = [:]
    var user: User? {
        didSet {
            updateViews()
        }
    }
    

    // Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    func updateViews() {
        
        guard isViewLoaded, let user = user else {return}
        
        navigationItem.title = user.name
        nameLabel.text = user.name
        phoneNumberLabel.text = user.phone
        emailLabel.text = user.email
        
        userImageView.image = userImage
        userImageView.contentMode = .scaleAspectFit
        
        loadingImage(for: user) // use loading image
        
    }
    
    // loading image from FetchDetailViewImageOperation
    private func loadingImage(for randomUsers: User) {
        
        if let image = cache.value(key: randomUsers.email) {
            userImageView.image = image
        } else {
            let fetchImageOp = FetchDetailViewImageOperation(user: randomUsers)
            
            let cacheOperation = BlockOperation {
                guard let image = fetchImageOp.largeImage else { return }
                self.cache.cache(value: image, key: randomUsers.email)
            }
            
            let setImageOp = BlockOperation {
                guard let image = fetchImageOp.largeImage else { return }
                self.userImageView.image = image
            }
            
            cacheOperation.addDependency(fetchImageOp)
            setImageOp.addDependency(fetchImageOp)
            operationQueue.addOperations([fetchImageOp, cacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(setImageOp)
            
            fetchOp[randomUsers.phone] = fetchImageOp
        }
    }

}
