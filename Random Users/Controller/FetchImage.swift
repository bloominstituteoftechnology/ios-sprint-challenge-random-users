//
//  FetchImage.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImage: ConcurrentOperation {
    
    //MARK: - Properties
    private var task: URLSessionDataTask?
    var imageData: Data?
    var large: String?
    var medium: String?
    var thumbnail: String?
    
    //TODO: Need an ID
    
    //MARK: - Initializer
    init(picture: Picture) {
        self.large = picture.large
        self.medium = picture.medium
        self.thumbnail = picture.thumbnail
    }
    
    
    //MARK: - Override Functions
    override func start() {
        super.start()
        state = .isExecuting
        
        //Fetch Image
        guard let stringURL = thumbnail else {
            return
        }
        
        guard let url = URL(string: stringURL) else {
            print("Bad URL")
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                return
            }
            
            //Store Image in Cache
            self.imageData = tempData
            self.state = .isFinished
            print("Got image!")
        }
        
        task?.resume()
    }
    
    //Canceling Data Task
    override func cancel() {
        super.cancel()
        if self.isCancelled {
            task?.cancel()
        }
    }
}
