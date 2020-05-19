//
//  APIController.swift
//  Random Users
//
//  Created by conner on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    
    enum NetworkError: Error {
        case noData
        case fetchError
        case unknownError
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    var users: [User] = []
    let usersLock = NSLock()
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=50")!
    
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                NSLog("Failed fetch: \(error)")
                return completion(.failure(.fetchError))
            }
            
            guard let data = data else {
                NSLog("Fetch returned, no data")
                return completion(.failure(.noData))
            }
            
            do {
                let users = try JSONDecoder().decode(Results.self, from: data)
                self.usersLock.lock()
                self.users.append(contentsOf: users.results)
                completion(.success(true))
                self.usersLock.unlock()
            } catch {
                NSLog("Failed to decode data to JSON")
                return completion(.failure(.unknownError))
            }
        }
        .resume()
    }
}
