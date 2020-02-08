//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Alex Shillingford on 2/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

    let person: Person
    let photoType: PhotoType
    private(set) var imageData: Data?
    private var urlSession: URLSession
    private var dataTask: URLSessionDataTask?

    init(photoType: PhotoType ,person: Person, urlSession: URLSession = URLSession.shared) {
        self.person = person
        self.urlSession = urlSession
        self.photoType = photoType
        super.init()
    }

    override func start() {
        guard let largePictureURL = person.largePicture.usingHTTPS, let thumbNailPicURL = person.thumbNail.usingHTTPS else { return }
        state = .isExecuting

        if photoType == .LargePicture {

            let task = urlSession.dataTask(with: largePictureURL) { (data, _ , error) in
                      defer{ self.state = .isFinished }
                      if self.isCancelled { return }
                      guard let data = data else {return}
                      if let error = error {
                          NSLog("error fetching image Data for \(self.person): \(error)")
                      }
                      self.imageData = data
                  }
                  task.resume()
                  dataTask = task

        } else if photoType == .thumbNail {

            let task = urlSession.dataTask(with: thumbNailPicURL) { (data, _ , error) in
                      defer{ self.state = .isFinished }
                      if self.isCancelled { return }
                      guard let data = data else {return}
                      if let error = error {
                          NSLog("error fetching image Data for \(self.person): \(error)")
                      }
                      self.imageData = data
                  }
                  task.resume()
                  dataTask = task
        }

    }

    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
