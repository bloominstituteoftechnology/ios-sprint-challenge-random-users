//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchUserOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    var result: Result<Data, Error>?
    let picture: Picture
    private (set) var imageData: Data?
    private var dataTask = URLSessionDataTask()
    private let session: URLSession
  
    init(picture: Picture, session: URLSession = URLSession.shared)  {
        self.picture = picture
        self.session = session
        super.init()
    }
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        let url = picture.imageURL
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                self.result = .failure(error)
                return
            }
        
            guard let data = data else { return }
            self.imageData = data
    
        }
        
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask.cancel()
    }
}
