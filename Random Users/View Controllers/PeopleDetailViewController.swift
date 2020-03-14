//
//  PeopleDetailViewController.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController {
    
    var userController: UserController?
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var largeImageCache: Cache<String, UIImage>?
    var photoFetchQueue: OperationQueue?
    var photoFetchOperation: PhotoFetchOperation?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Cancel when we go back to tableView before the image is loaded
        self.photoFetchOperation?.cancel()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        guard let user = user else { return }
        
        self.nameLabel?.text = "Name: \(user.name.capitalized)"
        self.phoneLabel?.text = "Phone: \(user.phone)"
        self.emailLabel?.text = "Email: \(user.email)"
        
//        self.imageView?.image =
        loadImage()
    }

    private func loadImage() {
        
        guard let url = user?.pictures["large"] else { return }
        guard let name = user?.name else { return }
        
        if let image = largeImageCache?.value(for: name) {
            imageView?.image = image
            
        } else {
            let photoFetchOperation = PhotoFetchOperation(url: url)
            let storeInCacheOperation = BlockOperation { [weak self] in
                guard let data = photoFetchOperation.pictureData else { return }
                guard let image = UIImage(data: data) else { return }
                self?.largeImageCache?.cache(value: image, for: name)
            }
            let updateCellOperation = BlockOperation { [weak self] in
                guard let image = self?.largeImageCache?.value(for: name) else { return }
                
                self?.imageView?.image = image
            }
            
            storeInCacheOperation.addDependency(photoFetchOperation)
            updateCellOperation.addDependency(storeInCacheOperation)
            
            photoFetchQueue?.addOperations([photoFetchOperation, storeInCacheOperation], waitUntilFinished: false)
            OperationQueue.main.addOperation(updateCellOperation)
            
            self.photoFetchOperation = photoFetchOperation
        }
    }
}
