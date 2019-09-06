//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

//import Foundation
//
//class FetchUserPhotoOperation: ConcurrentOperation {
//    var imageData: Data?
//    
//    var loadImageDataTask : URLSessionDataTask {
//        guard let httpURL = marsPhotoReference.imageURL.usingHTTPS else {
//            NSLog("cant make httpURL")
//            return URLSessionDataTask()
//        }
//        return URLSession.shared.dataTask(with: httpURL) { (data, response, error) in
//            defer {
//                self.state = .isFinished
//            }
//            if let error = error {
//                NSLog("Error doing load image dataTask: \(error)")
//                return
//            }
//            
//            guard let data = data else {
//                NSLog("no data return on load image")
//                return
//            }
//            
//            self.imageData = data
//            //print("load from internet")
//            
//        }
//    }
//    
//    override func start() {
//        state = .isExecuting
//        loadImageDataTask.resume()
//    }
//    
//    override func cancel() {
//        loadImageDataTask.cancel()
//    }
//    
//}
