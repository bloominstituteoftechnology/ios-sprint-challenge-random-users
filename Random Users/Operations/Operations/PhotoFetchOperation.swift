//
//  PhotoFetchOperation.swift
//  Astronomy
//
//  Created by Sergey Osipyan on 1/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    private var userReferences: RandomUser
    var thumbnailImage: Data?
    private var task: URLSessionDataTask?
   
    
    init(userReferences: RandomUser) {
        self.userReferences = userReferences
        super.init()
    }
    
    override func start() {
        super.start()
        self.state = .isExecuting
        
        guard let url = userReferences.thumbnailImageURL else { return }
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            guard let photoData = data else { return }
            DispatchQueue.main.async {
              
            self.thumbnailImage = photoData
        }
    }
        
        self.state = .isFinished
        task?.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
