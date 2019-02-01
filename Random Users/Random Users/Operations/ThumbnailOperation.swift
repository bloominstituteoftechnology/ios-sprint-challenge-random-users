//
//  ThumbnailOperation.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation

class ThumbnailOperation: ConcurrentOperation { //
    
    //Properties
    var thumbData: Data?
    let cellContact: User
    
    
    private var dataTask: URLSessionDataTask?
    
    init(contact: User) {
        self.cellContact = contact //Assigns the user passed into the init to the property
        super.init()
    }
    
    //Override the start function from ConcurrentOperation to modify it.
    override func start() {
        state = .isExecuting
        
        //Unwrap the image URL of the current user.
        guard let url = URL(string: cellContact.picture.thumbnail) else { return }
        
        // Download the image via data task
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            
            defer { self.state = .isFinished } //Fire this last.
            
            //Unwrap any errors
            if let error = error {
                NSLog("Couldn't download the image for \(self.cellContact.name): \(error)")
                return
            }
            
            //Unwrap the image data
            guard let data = data, data.count > 0 else {
                NSLog("There wasn't any data for the image")
                return
            }
            
            // Assign the image data to the propertyy
            self.thumbData = data
            
            return
        })
        
        dataTask?.resume() //End of Data Task
    } //End of Start Function
    
    //Cancel the data download if cancel is called.
    override func cancel() {
        dataTask?.cancel()
    }
}
