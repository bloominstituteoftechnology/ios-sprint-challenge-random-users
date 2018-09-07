//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation
{
    var person: Person
    var thumbnailImageData: Data?
    var dataTask: URLSessionDataTask?
    
    init(person: Person)
    {
        self.person = person
        super.init()
    }
    
    override func start()
    {
        state = .isExecuting
        
        guard let url = URL(string: person.picture.thumbnail) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if self.isCancelled
            {
                return
            }
            
            if let error = error
            {
                return
            }
            
            self.thumbnailImageData = data
            self.state = .isFinished
            
        }
        dataTask?.resume()
    }
    
    override func cancel()
    {
        dataTask?.cancel()
    }
}
