//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserOperation: ConcurrentOperation {
    
    let picture: Picture
    private (set) var imageData: Data?
    private var dataTask = URLSessionDataTask()
    
    
    override func start() {
        <#code#>
    }
    
    
    override func cancel() {
        
    }
    
    
}
