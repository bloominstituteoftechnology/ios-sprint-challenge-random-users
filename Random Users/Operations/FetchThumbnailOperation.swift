//
//  FetchThumbnailOperation.swift
//  Astronomy
//
//  Created by Jon Bash on 2019-12-05.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    var imageInfo: RandomUser.ImageInfo
    var forFullImage: Bool = false
    
    var imageData: Data?
    
    lazy private var dataTask: URLSessionDataTask? = {
        let url: URL
        if forFullImage {
            guard let imageURL = imageInfo.fullImageURL else { return nil }
            url = imageURL
        } else {
            guard let thumbnailURL = imageInfo.thumbnailURL else { return nil }
            url = thumbnailURL
        }
        
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: dataTaskDidComplete(with:_:_:))
        return task
    }()
    
    init(_ imageInfo: RandomUser.ImageInfo, forFullImage: Bool = false) {
        self.imageInfo = imageInfo
        self.forFullImage = forFullImage
    }
    
    override func start() {
        state = .isExecuting
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        state = .isFinished
    }
    
    private func dataTaskDidComplete(
        with possibleData: Data?,
        _ possibleResponse: URLResponse?,
        _ possibleError: Error?
    ) {
        defer { self.state = .isFinished }
        
        if let error = possibleError as NSError?,
            error.code == -999 {
            return
        } else if let error = possibleError {
            print("Error fetching image: \(error)")
            if let response = possibleResponse {
                print("Response:\n\(response)")
            }
            return
        }
        
        self.imageData = possibleData
    }
}
