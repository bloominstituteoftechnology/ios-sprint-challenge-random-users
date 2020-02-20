//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchUserOperation: ConcurrentOperation {
    
    // MARK: Properties
    
    var user: User
    
    private let session: URLSession

    var image: UIImage?
    
    private var dataTask: URLSessionDataTask?
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }
 
    override func start() {
        
        state = .isExecuting
        
        var request = URLRequest(url: baseURL)
        var requestUrl = user.imageUrl //.usingHTTPS! ?
        //request.httpMethod = "GET" //?
        
        let task = session.dataTask(with: requestUrl) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.user): \(error)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            guard let imageFromData = UIImage(data: data) else {
                print("No image from data")
                return
            }
            
            self.image = imageFromData
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
