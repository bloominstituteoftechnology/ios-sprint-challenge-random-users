//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    let requestURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1")
    var dataTask: URLSessionDataTask?
    var randomUserThumbnailData: Data?
    var indexPath: IndexPath?
    
    override func start() {
        self.state = .isExecuting
        fetchThumbnail()
    }
    
    func fetchThumbnail() {
        print(Model.shared.randomUsersCount)
        print(indexPath)
        guard let thumbnail = Model.shared.randomUsers?.results[(indexPath?.row)!].picture.thumbnail else {return}
        let actualURL = URL(string: (thumbnail))
        let thumbnailTask = URLSession.shared.dataTask(with: actualURL!) { (data, _, error) in
            self.randomUserThumbnailData = data
            self.state = .isFinished
        }
        dataTask = thumbnailTask
        thumbnailTask.resume()
    }
    override func cancel() {
        dataTask?.cancel()
    }
    
    
}

