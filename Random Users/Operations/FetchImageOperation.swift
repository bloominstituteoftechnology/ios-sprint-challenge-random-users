//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    let imageURL: URL
    var imageData: Data?
    
    // MARK: - Init
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init()
    }
    
    // MARK: - Private
    
    override func start() {
        state = .isExecuting
        
        fetchImageTask = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("Invalid response: \(response.statusCode)")
                return
            }
            
            guard let data = data else { return }
            
            self.imageData = data
        }
        
        fetchImageTask?.resume()
    }
    
    override func cancel() {
        fetchImageTask?.cancel()
    }
    
    private var fetchImageTask: URLSessionDataTask?
}
