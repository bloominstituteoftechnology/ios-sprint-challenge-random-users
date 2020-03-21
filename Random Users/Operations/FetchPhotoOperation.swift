////
////  FetchPhotoOperation.swift
////  Random Users
////
////  Created by denis cedeno on 3/21/20.
////  Copyright © 2020 Erica Sadun. All rights reserved.
////
//
import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    let userReference: User
    var imageData: Data?
    var thumbImage: UIImage?
    var largeImage: UIImage?
    var dataTask: URLSessionDataTask?
    var largeDataTask: URLSessionDataTask?
    
    
    init(userPhotoRefernce: User) {
        self.userReference = userPhotoRefernce
        super.init()
    }
    
    override func start() {
        
        state = .isExecuting
        let thumbNailURL = userReference.pictureThumbnail
        var requestURL = URLRequest(url: thumbNailURL)
        requestURL.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            print("URL:\(String(describing: requestURL))")
            defer { self.state = .isFinished }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                print("Error fetching image Data: \(error!)")
                return
            }
            self.imageData = data
            self.thumbImage = UIImage(data: self.imageData!)
            print("fetched image \(data)")
        }
        dataTask?.resume()
        
        
        
        let largeImageURL = userReference.pictureLarge
        var requestLargeURL = URLRequest(url: largeImageURL)
        requestLargeURL.httpMethod = "GET"
        
        largeDataTask = URLSession.shared.dataTask(with: requestLargeURL) { (data, _, error) in
            print("URL:\(String(describing: requestLargeURL))")
            defer { self.state = .isFinished }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let imageData = data else {
                print("Error fetching image Data: \(error!)")
                return
            }
            self.largeImage = UIImage(data: imageData)
            print("fetched image \(imageData)")
        }
        largeDataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        largeDataTask?.cancel()
    }
    
}




