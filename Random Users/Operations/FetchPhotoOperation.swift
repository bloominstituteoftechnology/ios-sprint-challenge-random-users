//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit
class FetchPhotoOperation: ConcurrentOperation {
    var imageURL: URL
    var imageData: UIImage?
    private var dataTask = URLSessionDataTask()
    typealias CompletionHandler = (Result<UIImage, NetworkError>) -> Void
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
    }
    
    
    func fetchImage(to imageURL: URL, completion: @escaping CompletionHandler) {
        
        var requestURL = URLRequest(url: imageURL)
        requestURL.httpMethod = HTTPMethod.get.rawValue
        
        dataTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { data, response, error in
            if let error = error {
            NSLog("Error in getting the image: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            guard let data = data else {
                NSLog("Error in getting data")
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
               NSLog("Error in getting imagedata")
                completion(.failure(.badData))
                return
            }
            completion(.success(image))
            })
        dataTask.resume()
    }
}
