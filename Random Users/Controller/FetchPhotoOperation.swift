//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: Properties
    let imageURL: URL
    var imageData: UIImage?
    private var dataTask: URLSessionDataTask?
    
    
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
        super.init()
    }
 
    override func start() {
        state = .isExecuting
        
        fetchImage(of: imageURL) { result in
            if let image = try? result.get() {
                self.imageData = image
                self.state = .isFinished
            }
        }
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    private func fetchImage(of imageUrl: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {

        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue

        dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                print("No data")
                completion(.failure(.noData))
                return
            }

            guard let image = UIImage(data: data) else {
                print("No data")
                completion(.failure(.noData))
                return
            }

            completion(.success(image))

        }
        dataTask!.resume()
    }
    
}
