//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit // For UIImage

class FetchPhotoOperation: ConcurrentOperation {
    var imageURL: URL
    var imageData: UIImage?
    var theDataTask: URLSessionDataTask? = nil
    
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
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
        if let dataTask = theDataTask {
            dataTask.cancel()
            print("Canceled dataTast!" )
        }
    }

    /// Fetch an image from the Internet via a URL
    /// - Parameters:
    ///   - imageUrl: A secure URL to the image you want to load
    ///   - completion: What do you want done with the downloaded image?
    private func fetchImage(of imageUrl: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        theDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving mars image data: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            guard let data = data else {
                NSLog("nasa.gov responded with no image data.")
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Image data is incomplete or corrupt.")
                completion(.failure(.badData))
                return
            }

            completion(.success(image))

        }
        
        // TODO: ? How can I combine with prior line?
        theDataTask!.resume()
    }
}
