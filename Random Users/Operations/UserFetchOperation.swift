//
//  UserFetchOperation.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

//=======================
// MARK: - Types
enum ImageType {
    case thumbnail
    case largeImage
}

class UserFetchOperation: ConcurrentOperation {
    //=======================
    // MARK: - Properties
    private var user: User
    private var dataTask: URLSessionDataTask?
    var imageData: Data?
    
    //=======================
    // MARK: - subclass methods
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        dataTask?.resume()
    }
    
    override func cancel() {
        state = .isFinished
        dataTask?.cancel()
    }
    
    //=======================
    // MARK: - Read
    func fetchPhoto(imageType: ImageType) {
        //construct URL
        var imgURL: URL?
        switch imageType {
        case .thumbnail:
            imgURL = user.thumbnailImage
        case .largeImage:
            imgURL = user.largeImage
        }
        guard let url = imgURL else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer {
                self.state = .isFinished
            }
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            self.imageData = data
        }
    }
}
