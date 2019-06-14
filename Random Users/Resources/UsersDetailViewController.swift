//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Ryan Murphy on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bigImageView: UIImageView!
    
 
        
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    var cache: Cache<String, Data>?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
        
    private func updateViews() {
        guard let image = bigImageView,
            let name = nameLabel,
            let email = emailLabel,
            let phone = phoneLabel,
            let cache = cache,
            let user = user else { return }
            
            if let cachedValue = self.cache?.value(for: user.phone) {
                let cachedImage = UIImage(data: cachedValue)
                image.image = cachedImage
                print("loaded")
            } else {
                
                let fetchLargeImageOperation = FetchLargeImageOperation(user: user)
                
                let addImageOpperation = BlockOperation {
                    if let imageData = fetchLargeImageOperation.imageData {
                        image.image = UIImage(data: imageData)
                    }
                    
                }
                
                let cacheOperation = BlockOperation {
                    guard let image = fetchLargeImageOperation.imageData else { return }
                    self.cache?.cache(value: image, for: user.phone)
                    print("cached")
                }
                
                addImageOpperation.addDependency(fetchLargeImageOperation)
                cacheOperation.addDependency(fetchLargeImageOperation)
                
                let fetchOpQueue = OperationQueue()
                
                fetchOpQueue.addOperation(fetchLargeImageOperation)
                fetchOpQueue.addOperation(cacheOperation)
                OperationQueue.main.addOperation(addImageOpperation)
            }
            
        
            email.text = user.email
            phone.text = user.phone
            name.text = "\(user.name.title.capitalized) \(user.name.first.capitalized) \(user.name.last.capitalized)"
            navigationItem.title = "\(name.text ?? "")"
        }
        

}
