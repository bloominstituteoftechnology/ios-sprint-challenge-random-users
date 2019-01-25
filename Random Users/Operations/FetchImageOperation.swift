//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    var randomUser: RandomUser?
    var imageData: Data?
    
    init(randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    override func start() {
        self.state = .isExecuting
        
    }
    
    
}
