//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var user: User?
    var photoFetchQueue: OperationQueue?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        fetchImage(for: user)
    }
    
    private func fetchImage(for user: User) {
        
        let photoString = user.photo
        
        //        if let imageData = cache.retrieveValue(for: photoReference.id),
        //            let image = UIImage(data: imageData) {
        //            cell.imageView.image = image
        //            return
        //        }
        
        let photoFetchOperation = FetchPhotoOperation(photoString: photoString)
        
        //        let storeData = BlockOperation {
        //            if let imageData = photoFetchOperation.imageData {
        //                self.cache.cache(value: imageData, for: photoReference.id)
        //            }
        //        }
        
        let setImage = BlockOperation {
            //            defer { self.fetchOperations.removeValue(forKey: photoReference.id) } // So we use less memory
            print("hi")
            guard let data = photoFetchOperation.imageData else { return }
            let image = UIImage(data: data)
            self.imageView.image = image
        }
        
        setImage.addDependency(photoFetchOperation)
        //        storeData.addDependency(photoFetchOperation)
        
        photoFetchQueue?.addOperations([photoFetchOperation/*, storeData*/], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImage)
        
        //        fetchOperations[photoReference.id] = photoFetchOperation
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
