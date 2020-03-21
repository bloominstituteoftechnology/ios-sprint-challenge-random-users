////
////  FetchPhotoOperation.swift
////  Random Users
////
////  Created by denis cedeno on 3/21/20.
////  Copyright © 2020 Erica Sadun. All rights reserved.
////
//
import Foundation
//
//class FetchPhotoOperation: ConcurrentOperation {
//    let userReference: User
//    var imageData: Data?
//    var dataTask: URLSessionDataTask?
//
//
//    init(userPhotoRefernce: User) {
//        self.userReference = userPhotoRefernce
//
////        super.init()
//    }
//
//    override func start() {
//
//        state = .isExecuting
////        guard let url = userReference.pictureThumbnail.usingHTTPS
////
//
//        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
//            print("URL:\(String(describing: url))")
//            defer { self.state = .isFinished }
//            if let error = error {
//                print("Error fetching data: \(error)")
//                return
//            }
//            if let data = data {
//                self.imageData = data
//                print("fetched image \(data)")
//            }
//        }
//        dataTask?.resume()
//    }
//    override func cancel() {
//        dataTask?.cancel()
//    }
//}
//
//
//
//
