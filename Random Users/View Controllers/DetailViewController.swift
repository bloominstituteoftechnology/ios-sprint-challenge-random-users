//
//  DetailViewController.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var user: User? {
        didSet{
            updateViews()
        }
    }
    
    var cache: Cache<String, [UIImage]>?
    private let photoFetchQueue = OperationQueue()
    let queue = OperationQueue.main
    var storedOperations: [String : Operation] = [:]
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userPhoneNumber: UILabel!
    @IBOutlet var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        loadImage()
    }
    
    func updateViews() {
        guard let user = user, isViewLoaded else { return }
        
        let name = user.name
        let first = name.first
        let last = name.last
        let fullName = "\(first.capitalized) \(last.capitalized)"
        
        userName.text = fullName
        userPhoneNumber.text = user.phone
        userEmail.text = user.email
    }
    private func loadImage() {
        guard let user = user else { return }
        
        if let images = cache?.value(forKey: user.email), images.count == 2, let image = cache?.value(forKey: user.email)?[1] {
            
            userImage.image = image
            return
        }
        
        let fetchImage = FetchThumbnailOperation(user: user, imageURL: user.picture.large)
        
        let storeDataOperation = BlockOperation {
            guard let data = fetchImage.imageData else {
                NSLog("fetchThumb.imageData does not have valid data for large image")
                return
            }
            let largeImage = UIImage(data: data) ?? #imageLiteral(resourceName: "MarsPlaceholder")
            let thumbImage = self.cache?.value(forKey: user.email)![0] ?? #imageLiteral(resourceName: "MarsPlaceholder")
            self.cache?.cache(value: [thumbImage, largeImage], forKey: user.email)
        }
        
        let setImageViewOperation = BlockOperation {
            if let data = fetchImage.imageData,
                let image = UIImage(data: data) {
            
                self.userImage.image = image
                
                return
            }
        }
        
        storeDataOperation.addDependency(fetchImage)
        setImageViewOperation.addDependency(fetchImage)
        photoFetchQueue.addOperations([fetchImage, storeDataOperation], waitUntilFinished: true)
        queue.addOperation(setImageViewOperation)
        storedOperations[user.email] = fetchImage
        
    }
    
}
