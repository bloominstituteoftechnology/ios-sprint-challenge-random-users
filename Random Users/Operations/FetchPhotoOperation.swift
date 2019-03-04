//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    init(person: Person, photoType: String) {
        self.person = person
        self.photoType = photoType
    }
    
    override func start() {
        state = .isExecuting
        
        print("fetch started")
        
        let imageURL = person.picture[photoType]
        
        self.task = URLSession.shared.dataTask(with: imageURL!) { (data, _, error) in
            
            defer{
                self.state = .isFinished
            }
            
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(error)")
                return
            }
            print("fetched data: \(data)")
            self.imageData = data
        }
        task!.resume()
    }
    
    override func cancel() {
        print("data task cancelled")
        task?.cancel()
    }
    
    var task: URLSessionDataTask?
    
    let person: Person
    var photoType: String
    
    var imageData: Data?
}
