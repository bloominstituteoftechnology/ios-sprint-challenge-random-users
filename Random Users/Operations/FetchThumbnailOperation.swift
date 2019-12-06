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
    
    var thumbnailData: Data?
    
    lazy private var dataTask: URLSessionDataTask? = {
        guard let url = imageInfo.thumbnailURL else { return nil }
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: dataTaskDidComplete(with:_:_:))
        return task
    }()
    
    init(_ imageInfo: RandomUser.ImageInfo) {
        self.imageInfo = imageInfo
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
        
        self.thumbnailData = possibleData
    }
}
