//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit
class FetchPhotoOperation: ConcurrentOperation {
    var imageURL: URL
    var imageData: UIImage?
    private var dataTask = URLSessionDataTask()
    
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
    }
}
