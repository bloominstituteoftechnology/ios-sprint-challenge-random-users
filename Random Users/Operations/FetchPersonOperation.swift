//
//  FetchPersonOperation.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPersonOperation: ConcurrentOperation {
    
    private(set) var photoData: Data?
    private var task: URLSessionTask?
    let person: Person
    
    init(person: Person) {
        self.person = person
        super.init()
    }
    
    override func start() {
        super.start()
        state = .isExecuting
        
        let url = self.person.picture
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            
            if self.isCancelled { return }
            
            if let error = error {
                print("Error getting photo: \(error)")
                return
            }
            self.photoData = data
        }
        task.resume()
        self.task = task
    }
    
    override func cancel() {
        super.cancel()
        if let task = self.task {
            task.cancel()
        }
    }
    
}
