//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let image = userImageView,
        let name = nameLabel,
        let email = emailLabel,
        let phone = phoneNumberLabel,
            let user = user else { return }
        
        if let cachedValue = self.cache.value(for: user.phone) {
            let cachedImage = UIImage(data: cachedValue)
            image.image = cachedImage
        } else {
            
            let fetchLargeImageOperation = FetchLargeImageOperation(user: user)
            
            let addImageOp = BlockOperation {
                if let imageData = fetchLargeImageOperation.imageData {
                    image.image = UIImage(data: imageData)
                }
            }
            
            let cacheOperation = BlockOperation {
                guard let image = fetchLargeImageOperation.imageData else { return }
                self.cache.cache(value: image, for: user.phone)
            }
            
            addImageOp.addDependency(fetchLargeImageOperation)
            cacheOperation.addDependency(fetchLargeImageOperation)
            
            let fetchOpQueue = OperationQueue()
            
            fetchOpQueue.addOperation(fetchLargeImageOperation)
            fetchOpQueue.addOperation(cacheOperation)
            OperationQueue.main.addOperation(addImageOp)
        }
        
        name.text = "\(user.name.title.capitalized) \(user.name.first.capitalized) \(user.name.last.capitalized)"
        email.text = user.email
        phone.text = user.phone
    }
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    let cache = Cache<String, Data>()
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
}
