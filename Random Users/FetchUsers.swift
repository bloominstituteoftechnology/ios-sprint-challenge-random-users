//
//  FetchUsers.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUsers: ConcurrentOperation {
    var imageData: Data?
    private var dataTask: URLSessionTask?
    let person: User
    
    init(person: User) {
        self.person = person
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = self.person.thumbnail
        
        dataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error  = error {
                print("Error with data task: \(error)")
            }
            
            guard let data = data else {
                print("Error getting data")
                return
            }
            
            self.imageData = data
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
