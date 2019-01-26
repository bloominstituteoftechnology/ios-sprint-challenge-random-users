//
//  PhotoOperation.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class PhotoOperation: ConcurrentOperation { //
    
        // MARK: - Properties
        var photoData: Data?
        let theUser: User
        let sizes: photoSizes
    
    
        private var dataTask: URLSessionDataTask?
        
        // MARK: - Initializers
        init(theUser: User, size: photoSizes = .thumbnail) {
            self.theUser = theUser //Assigns the user passed into the init to the property
            self.sizes = size //Assigns the size passed into the the init to the property
            super.init()
        }
        
        // MARK: Operation
        override func start() {
            state = .isExecuting
            
            //Build the URLs for each image type
            var url: URL?
            let thumbURL = URL(string: theUser.picture.thumbnail)
            let largeURL = URL(string: theUser.picture.large)
            
            //Switch to the correct URL depending on the type of image
            switch sizes {
            case .thumbnail:
                url = thumbURL
            case .large:
                url = largeURL
            }
            
            //Set the download URL
            //urguard let requestURL = url else { return }
            
            
            // Download the image via data task
            dataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
                
                defer { self.state = .isFinished } //Fire this last.
                
                //Unwrap any errors
                if let error = error {
                    NSLog("Error GETing image for \(self.theUser.name): \(error)")
                    return
                }
                
                //Unwrap the image data
                guard let data = data, data.count > 0 else {
                    NSLog("No data was returned")
                    return
                }
                
                // Assign the image data to the propertyy
                self.photoData = data
                
                return
            })
            
            dataTask?.resume() //End of Data Task
        } //End of Start Function
    
    //Cancel the data download if canceled.
        override func cancel() {
            dataTask?.cancel()
        }
    }

// The two photo sizes available
enum photoSizes: String {
    case thumbnail
    case large
}
