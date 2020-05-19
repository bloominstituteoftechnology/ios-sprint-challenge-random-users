//
//  Cache.swift
//  Random Users
//
//  Created by Breena Greek on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class Cache {
    
    static let cache = Cache()
    private init() {}
    
    var thumbnailImageCache: [User: UIImage] = [:]
    var detailImageCache: [User: UIImage] = [:]
      
    private let accessQueue = DispatchQueue(label: "com.LambdaSchool.RandomUser.ImageCacheQueue")
    
    subscript (thumbnail user: User) -> UIImage? {
        get {
            // Ensure atomic read of cache and thumbnailCache
            return accessQueue.sync { thumbnailImageCache[user] }
        }
        set {
            accessQueue.async { self.thumbnailImageCache[user] = newValue }
        }
    }

    subscript (_ user: User) -> UIImage? {
        get {
            return accessQueue.sync { detailImageCache[user] }
        }
        set {
            accessQueue.async { self.detailImageCache[user] = newValue }
        }
    }
}
