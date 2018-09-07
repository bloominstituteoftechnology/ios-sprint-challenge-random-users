//
//  UserController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    func getUsers(completion: @escaping (Error?) -> Void) {
        let url = UserController.baseURL
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser data: \(error) - \(url)")
                completion(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let randomUserJSON = try decoder.decode(Results.self, from: data)
                
                self.users = randomUserJSON.results.compactMap { $0 }
            } catch let error {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func loadUserImageForCell(user: User, cell: UITableViewCell) {
        let userId = user.email
        
        let isCached = cache.cachedItems.contains(where: { (key, value) -> Bool in
            key == userId
        })
        
        if isCached {
            guard let imageData = cache.cachedItems[userId] else { return }
            cell.imageView?.image = UIImage(data: imageData)
            return
        }
        
        photoFetchQueue.name = "PhotoFetchQueue"
        
        let fetchPhoto = FetchPhotoOperation(user: user)
        
        let cacheOperation = BlockOperation {
            guard let imageData = fetchPhoto.imageData else { return }
            self.cache.cache(value: imageData, for: userId)
        }
        
        let imageSetOperation = BlockOperation {
            guard let imageData = fetchPhoto.imageData else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        
        cacheOperation.addDependency(fetchPhoto)
        imageSetOperation.addDependency(fetchPhoto)
        
        
        self.photoFetchQueue.addOperations([fetchPhoto, cacheOperation, imageSetOperation], waitUntilFinished: false)
    }
    
    
    func loadUserImageForDetail(user: User, imageView: UIImageView) {
        let url = URL(string: user.picture.large)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser photo: \(error) - \(url)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    var users: [User] = []
    var cache: Cache<String, Data> = Cache()
    private var photoFetchQueue: OperationQueue = OperationQueue()
    static var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
