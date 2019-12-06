//
//  FetchPhotos.swift
//  Random Users
//
//  Created by Jerry haaser on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPeoplePhotosOperation: ConcurrentOperation {
    
    let person: Person
    
    private (set) var imageData: Data?
    private let session: URLSession
    private var dataTasks: URLSessionDataTask?
    
    init(person: Person, session: URLSession = URLSession.shared) {
        self.person = person
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        guard let url = person.picture.large.usingHTTPS else { return }
        
        let task = session.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            
            if let error = error {
                NSLog("Error with data task: \(self.person), \(error)")
                return
            }
            
            guard let data = data else { return }
            self.imageData = data
        }
        
        task.resume()
        dataTasks = task
    }
    
    override func cancel() {
        dataTasks?.cancel()
        super.cancel()
    }
}

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
