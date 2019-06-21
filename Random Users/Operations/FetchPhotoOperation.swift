//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    //we just want to fetch the photo so we use the user to get the photoURLs
    var user: User
    var imageURL: URL?
    var imageData: Data? //assign the data we get back so that we can load the image in the table View cell (uiimage(data: data)
    
    //create a dataTask so we can cancel it
    private var dataTask: URLSessionDataTask?
    
    init(user: User, imageURL: URL){
        self.user = user
        self.imageURL = imageURL
    }
    
    override func start() {
        //tell the operation queue machinery that the operation has started running
        state = .isExecuting
        
        //this will be called on the table view so I'm thinking that we want the large photos to be fetched.
        guard let url = imageURL else { print("FetchPhotoOperation: Error with constructing url"); return }
        
        //create a dataTask to load the image. You should store the task itself in a private property so you can cancel it if need be.
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            if let response = response as? HTTPURLResponse {
//                print("This is the FetchPhotoOperation status code: \(response.statusCode)")
            }
            if let error = error {
                print("Error in FetchPhotoOperation network call: \(error.localizedDescription), better description of ERROR: \(error)")
                return
            }
            guard let data = data else { print("Error getting data back in FetchPhotoOperation server call"); return }
            self.imageData = data
            defer { self.state = .isFinished }
        }
        
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}

