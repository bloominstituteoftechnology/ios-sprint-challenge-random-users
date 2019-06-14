//
//  FetchLargeImageOperation.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class FetchLargeImageOperation: ConcurrentOperation {
    
    let person: Person
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    private let session: URLSession
    
    init(person: Person, session: URLSession = URLSession.shared) {
        self.person = person
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let imageURL = URL(string: person.largeImage) else { return }
        let url = imageURL.usingHTTPS!
        dataTask = session.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching thumbnail for \(self.person.name): \(error)")
                return
            }
            self.imageData = data
        }
        dataTask?.resume()
        
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
}
