//
//  FetchPictureOperation.swift
//  Random Users
//
//  Created by Vici Shaweddy on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchPictureOperation: ConcurrentOperation {
    private let url: URL
    private var dataTask: URLSessionDataTask?
    var image: UIImage?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    override func start() {
        super.start()
        self.state = .isExecuting
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { self.state = .isFinished }
            
            guard error == nil else { return }
            
            if let data = data {
                self.image = UIImage(data: data)
            }
        }
        self.dataTask = dataTask
        self.dataTask?.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.dataTask?.cancel()
        print("Cancel the operation")
    }
}
