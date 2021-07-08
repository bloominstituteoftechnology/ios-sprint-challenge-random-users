//
//  ImageFetchOperation.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class ImageFetchOperation: ConcurrentOperation
{
    var picture: Picture
    var thumbnail: UIImage?
    
    init(picture: Picture) {
        self.picture = picture
    }
    
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        
        guard let url = picture.thumbnail else { return }
        var request = URLRequest(url: url)
        dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error retrieving image from url: \(error)")
                return
            }
            guard let data = data else { return }
            self.thumbnail = UIImage(data: data)
        }
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
