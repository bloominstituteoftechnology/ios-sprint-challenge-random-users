//
//  ImageCache.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class CachedImages {
    static let shared = CachedImages()
    private var thumbnails: [User: UIImage] = [:]
    private var images: [User: UIImage] = [:]
    private let randomUsersQueue = DispatchQueue(label: "com.LambdaSchool.RandomUser.ImageCacheQueue")
    private init() {}
    
    subscript (thumbnail user: User) -> UIImage? {
        get {
            return randomUsersQueue.sync { thumbnails[user] }
        }
        set {
            randomUsersQueue.async { self.thumbnails[user] = newValue }
        }
    }
    
    subscript (_ user: User) -> UIImage? {
        get {
            return randomUsersQueue.sync { images[user] }
        }
        set {
            randomUsersQueue.async { self.images[user] = newValue }
        }
    }
}
