//
//  Manager.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit

class Manager {
    
    static let shared = Manager()
    
    var contacts: [User] = []

    //Properties
    private var thumbQueue = OperationQueue() //My background queue for thumbnails
    private let cache = Cache<String, Data>() //My cache
    
    //Each thumbnail download operation for each cell will live here.
    private var thumbnailDownloads: [String: ThumbnailOperation] = [:]
    
    
    func loadThumb(for cell: CellController, at indexPath: IndexPath) {
        
        // Get the contact for the indexPath
        let user = contacts[indexPath.row]
        
        // If there's already cached thumbnail data for that contact ID...
        if let thumbnailData = cache.getValue(for: user.login.uuid) {
            cell.thumbView.image = UIImage(data: thumbnailData) } //update the cell's thumbnail with it.
        
        // Otherwise, fetch the thumbnail through an instance of Thumbnail Operation
        let thumbnailOperation = ThumbnailOperation(contact: user)
        
        // Then cache the data using a block operation
        let cacheThumbOperation = BlockOperation {
            if let thumbnailData = thumbnailOperation.thumbData {
                self.cache.saveToCache(value: thumbnailData, for: user.login.uuid) }
        }
        
        // Then update the UI using another block operation
        let updateThumbOperation = BlockOperation {
            if let imageData = thumbnailOperation.thumbData {
                cell.thumbView.image = UIImage(data: imageData)
                cell.setNeedsLayout() // Reloads the cell
            }
        }
        
        
        //Dependencies.
        
        //Caching the thumbnail is dependent on successfully downloading the thumbnail
        cacheThumbOperation.addDependency(thumbnailOperation)
        
        //Updating the thumbnail is dependent on successfully downloading the thumbnail
        updateThumbOperation.addDependency(thumbnailOperation)
        
        //Adds each thumbnail download to the dictionary under the unique key of each user's UUID.
         thumbnailDownloads[user.login.uuid] = thumbnailOperation
        
        
        //Queuing
        
        //Add the thumbnail download operation and the caching op to the background queue
        thumbQueue.addOperation(thumbnailOperation)
        thumbQueue.addOperation(cacheThumbOperation)
                
        //Add the update thumbnail operation to the main Queue since it's part of the UI
        OperationQueue.main.addOperation(updateThumbOperation)
        
    }

}
