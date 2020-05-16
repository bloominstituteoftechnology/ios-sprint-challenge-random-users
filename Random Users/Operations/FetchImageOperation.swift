//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchImageOperation: ConcurrentOperation {
    
    let url: URL
    var uiImage: UIImage?
    var dataTask: URLSessionDataTask?
    
    init(url: URL) {
        self.url = url
    }
    
    override func start() {
        
        state = .isExecuting
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { self.state = .isFinished }
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            guard let image = UIImage(data: data) else { fatalError() }
            self.uiImage = image
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        
        dataTask?.cancel()
    }
}
