//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    private let photoFetchQueue = OperationQueue()
    private var fetchDictionary: [String: Operation] = [:]
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let user = user else {
            return
        }
        
        let photoFetchOperation = FetchUserPhotoOperation(imageURL: user.thumbnail)
        let saveCacheOperation = BlockOperation {
            self.cache.cache(value: photoFetchOperation.imageData!, for: user.thumbnail)
        }
        let setUpImageViewOperation = BlockOperation {
            DispatchQueue.main.async {
                
                cell.profileImageView.image = UIImage(data: photoFetchOperation.imageData!)
                
            }
        }
        if let imageData = cache.value(for: user.thumbnail) {
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.profileImageView.image = image
                print("loaded cache image")
                return
            }
        }
        
        saveCacheOperation.addDependency(photoFetchOperation)
        setUpImageViewOperation.addDependency(photoFetchOperation)
        photoFetchQueue.addOperations([photoFetchOperation, saveCacheOperation, setUpImageViewOperation], waitUntilFinished: true)
        
        fetchDictionary[user.thumbnail] = photoFetchOperation
    }

}
