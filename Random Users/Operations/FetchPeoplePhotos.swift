//
//  FetchPeoplePhotos.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPeoplePhotoOperation: ConcurrentOperation {
    
    let person: Person
    
    private (set) var imageData: Data?
    private let session: URLSession
    private var dataTaks: URLSessionDataTask?
    
    init(person: Person, session: URLSession = URLSession.shared) {
        self.person = person
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        guard let url = person.picture[0].usingHTTPS else {return}
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            
            if let error = error {
                NSLog("Error with data task: \(self.person), \(error)")
                return
            }
            
            guard let data = data else {return}
                       self.imageData = data
        }
        
        task.resume()
        dataTaks = task
    }
    
    override func cancel() {
        dataTaks?.cancel()
        super.cancel()
    }
}
