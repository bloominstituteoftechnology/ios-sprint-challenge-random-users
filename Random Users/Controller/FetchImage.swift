//
//  FetchImage.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImage {
    
    //MARK: - Properties
    private var dataTask: URLSessionDataTask?
    var imageData: Data?
    var large: String?
    var medium: String?
    var thumbnail: String?
    var indexPath: IndexPath? //Acts as the ID
    
    //MARK: - Initializer
    init(picture: Picture, indexPath: IndexPath) {
        self.large = picture.large
        self.medium = picture.medium
        self.thumbnail = picture.thumbnail
        self.indexPath = indexPath
    }
    
    //MARK: - Custom Functions
    func start(completion: @escaping (Data?) -> Void) {

        //Fetch Image
        guard let stringURL = thumbnail else {
            return
        }
        
        guard let url = URL(string: stringURL) else {
            print("Bad URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                completion(nil)
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                completion(nil)
                return
            }
            
            //Store Image in Cache
            self.imageData = tempData
            completion(tempData)
        }
        
        task.resume()
        dataTask = task
    }
    
    //Canceling Data Task
    func cancel() {
        print("Task Canceled")
        dataTask?.cancel()
    }
}
