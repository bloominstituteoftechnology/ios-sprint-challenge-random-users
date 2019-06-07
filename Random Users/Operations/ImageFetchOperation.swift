//
//  ImageFetchOperation.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class ImageFetchOperation: ConcurrentOperation {
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(with user: User) {
        self.user = user
    }
}
