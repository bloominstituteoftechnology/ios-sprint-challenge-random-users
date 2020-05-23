//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Thomas Dye on 5/23/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    var user: User?
    var userIndex: Int?
    var userController: UserController?
    private let photoFetchQueue = OperationQueue()
    var fetchPhotoOperations: FetchPhotoOperation?
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoFetchQueue.name = "com.RandomeUsers.UserDetailViewController"
        setUpViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            fetchPhotoOperations?.cancel()
        }
    }
    
    func setUpViews() {
        guard let user = user else { return }
        nameLabel?.text = user.name
        phoneLabel?.text = "Phone Number: \(user.phone)"
        emailLabel?.text = "Email Address: \(user.email)"
        fetchCurrentImage(with: user.picture[2])
        
        //Changing the navigation controller's name for the Current user being viewed.
        navigationItem.title = user.name
    }
    
    
    func fetchCurrentImage(with url: String) {
        guard let userIndex = userIndex else { return }
        
        if let imageData = userController?.largeImageCache.value(for: userIndex) {
            userImageView.image = UIImage(data: imageData)
        }
        
        let fetchPhotoOperation = FetchPhotoOperation(userImageUrl: url)
        let storeToCache = BlockOperation {
            if let imageData = fetchPhotoOperation.imageData {
                self.userController?.largeImageCache.cache(value: imageData, for: userIndex)
            }
        }
        
        let setImageOp = BlockOperation {
            guard let imageData = fetchPhotoOperation.imageData else { return }
            self.userImageView?.image = UIImage(data: imageData)
        }
        
        storeToCache.addDependency(fetchPhotoOperation)
        setImageOp.addDependency(fetchPhotoOperation)
        
        photoFetchQueue.addOperations([fetchPhotoOperation, storeToCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImageOp)
        fetchPhotoOperations = fetchPhotoOperation
    }
}
