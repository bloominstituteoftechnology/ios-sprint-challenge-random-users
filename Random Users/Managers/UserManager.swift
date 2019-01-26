//
//  UserManager.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserManager {
    
    static let shared = UserManager()
    
    var addressbook: [User] = []
    
    
    
    //Properties
    let thumbQueue = OperationQueue()
    private let cache = Cache<String, Data>()
    private var photoOperations: [String: PhotoOperation] = [:]
    var cellImage: UIImage? = nil
    
    
    // MARK: - Utility Methods
     func loadImage(for cell: UITableViewCell, at indexPath: IndexPath) {
        
        // Get the contact for the indexPath
        let contact = addressbook[indexPath.row]
        
        // If there is already cached imageData for that contact, update the cell with that and return
        if let imageData = cache.value(for: contact.email) { //
            cellImage = UIImage(data: imageData) 
            
        }
        
        // Otherwise, make an operation to fetch the thumbnail
        let thumbnailDownloadOP = PhotoOperation(theUser: contact, size: .thumbnail)
        
        // And an operation to cache the data
        let cacheImageOperation = BlockOperation {
            if let imageData = thumbnailDownloadOP.photoData {
                self.cache.cache(value: imageData, for: contact.email)
            }
        }
        // And an operation to update the UI when it is returned
        let updateUIOperation = BlockOperation {
            if let imageData = thumbnailDownloadOP.photoData { //
                self.cellImage = UIImage(data: imageData)
                //cell.setNeedsLayout()
            }
        }
        
        // Make the cache and UI operations dependent on fetching the thumbnail
        cacheImageOperation.addDependency(thumbnailDownloadOP)
        updateUIOperation.addDependency(thumbnailDownloadOP)
        
        // Add the operation to the private dictionary, so we can cancel it later if necessary
        photoOperations[contact.email] = thumbnailDownloadOP
        
        // Add the operations to their respective queues
        thumbQueue.addOperation(thumbnailDownloadOP)
        thumbQueue.addOperation(cacheImageOperation)
        OperationQueue.main.addOperation(updateUIOperation)
        
       
        
        //return cellImage!
    }
    
    
    
}
