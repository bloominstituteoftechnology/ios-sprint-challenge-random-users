//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Properties
    var person: Person
    var imageData: Data?
    var urlSessionDataTask: URLSessionDataTask?
    
    
    init(person: Person) {
        self.person = person
    }
    
    
    override func start() {
        state = .isExecuting
        
        let url = URL(string: person.picture["thumbnail"]!)!
        
        urlSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error : \(error)")
                return
            }
            
            if let data = data {
                self.imageData = data
            }
            
            self.state = .isFinished
            
            
        })
        urlSessionDataTask?.resume()
    }
    
    override func cancel() {
        urlSessionDataTask?.cancel()
        super.cancel()
    }
    
    
}
