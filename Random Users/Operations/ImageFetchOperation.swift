//
//  ImageFetchOperation.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 4/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ImageFetchOperation: ConcurrentOperation {
    
    var url: URL
    var userController: UserController
    var image: UIImage?
    
    init(userController: UserController, url: URL) {
        self.userController = userController
        self.url = url
    }
    
    override func start() {
        self.state = .isExecuting
        userController.fetchImage(for: url) { [weak self] result in
            guard let self = self else { return }
            defer { self.state = .isFinished }
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}
