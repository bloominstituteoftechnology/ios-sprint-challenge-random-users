//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum ImageSize {
    case thumbnail
    case large
}

class FetchPhotoOperation: ConcurrentOperation {
    
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    var imageSize: ImageSize
    
    var user: User
    var imageData: Data?
    
    init(user: User, session: URLSession = URLSession.shared, imageSize: ImageSize) {
        self.user = user
        self.session = session
        self.imageSize = imageSize
        super.init()
    }
    
    override func start() {
        state = .isExecuting
    }
    
    override func cancel() {
        dataTask?.cancel()
    }

    func fetchImage(from url: URL, using session: URLSession = URLSession.shared, completion: @escaping (Data?, Error?) -> Void) {
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.LambdaSchool.RandomUsers.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            completion(data, nil)
            self.imageData = data
        }.resume()
    }
}
