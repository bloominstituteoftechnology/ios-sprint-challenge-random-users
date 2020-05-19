//
//  UserController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class UserController {
    
    //MARK: - Properties -
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    var baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    var users: [User] = []
    
    //MARK: - Methods -
    
//    init() {
//        getUser(completion: { _ in } )
//    }
    
    func getUser(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(.otherError))
                NSLog("URLSession failed: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                NSLog("Could not get data: \(String(describing: error))")
                return
            }
            
            do {
                let randomUser = try JSONDecoder().decode(RandomUsers.self, from: data)
                self.users = randomUser.results
                completion(.success(true))
            } catch {
                completion(.failure(.noDecode))
                NSLog("Could not decode generated user data: \(error)")
                return
            }
        }
        dataTask.resume()
    }
    
    func getUserImage(imageURLString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        let imageURL = URL(string: imageURLString)!
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(.otherError))
                NSLog("URLSession failed: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(.otherError))
                NSLog("Could not get data: \(String(describing: error))")
                return
            }
            
            let image = UIImage(data: data)!
            
            completion(.success(image))
            
        }
        dataTask.resume()
    }
    
}
