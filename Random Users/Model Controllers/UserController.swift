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
    var baseURL: URL? = nil
    var users: [User] = []
    
    //MARK: - Methods -
    
    func urlForFetching(numberOfUsers: Int) -> URL {
        
        let endPoint = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture")!
        var components = URLComponents(url: endPoint, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "format", value: "json"),
                                 URLQueryItem(name: "inc", value: "name,email,phone,picture"),
                                 URLQueryItem(name: "results", value: String(numberOfUsers))]
        baseURL = components.url!
        return components.url!
        
    }
    
    func getUser(row: Int, completion: @escaping (Result<User, NetworkError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: baseURL!) { (data, _, error) in
            
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
                let randomUser = try JSONDecoder().decode(User.self, from: data)
                self.users.insert(randomUser, at: row)
                completion(.success(randomUser))
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
