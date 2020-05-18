//
//  UserController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

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
    let baseURL: URL = URL(string: "https://randomuser.me/api/?inc=name,email,phone")!
    var users: [User] = []
    
    //MARK: - Methods -
    
    func getUser(completion: @escaping CompletionHandler) {
        
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
                let randomUser = try JSONDecoder().decode(User.self, from: data)
                self.users.append(randomUser)
            } catch {
                completion(.failure(.noDecode))
                NSLog("Could not decode generated user data: \(error)")
                return
            }
            completion(.success(true))
        }
        dataTask.resume()
    }
    
    
}
