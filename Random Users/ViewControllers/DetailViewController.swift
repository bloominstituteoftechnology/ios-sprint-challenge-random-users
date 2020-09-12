//
//  DetailViewController.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    // MARK: - Properties
    
    var user: User?
    
    private var cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    private var fetchDictionary: [String: FetchPhotoOperation] = [:]
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            self.updateViews(with: user)
        }
    }

    // MARK: - Functions
    
    private func updateViews(with user: User) {
        loadImage()
        nameLabel.text = "\(user.first) \(user.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
    private func loadImage() {
        
        guard let user = user else { return }
        let userID = user.email
        if let imageData = cache[userID] {
            imageView.image = UIImage(data: imageData)
        } else {
            let fetchImage = FetchPhotoOperation(user: user, imageType: .large)
            let cacheImage = BlockOperation {
                if let data = fetchImage.imageData {
                    self.cache.cache(key: userID, value: data)
                }
            }
            let setImage = BlockOperation {
                if let data = fetchImage.imageData {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
            cacheImage.addDependency(fetchImage)
            setImage.addDependency(fetchImage)
            photoFetchQueue.addOperations([fetchImage, cacheImage, setImage], waitUntilFinished: false)
            fetchDictionary[userID] = fetchImage
        }
    }

}
