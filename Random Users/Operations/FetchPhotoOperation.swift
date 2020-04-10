//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    let face: Face
    private let aSession: URLSession
    private(set) var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(face: Face, session: URLSession = URLSession.shared) {
        self.face = face
        self.aSession = session
        super.init()
    }
 
    override func start() {
        state = .isExecuting
        let url = URL(string: face.thumbnail)!

        let task = aSession.dataTask(with: url) { (data, response, error) in
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.face.name): \(error)")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
}

