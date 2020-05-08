//
//  APIController.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    
    enum NetworkError: Error {
        case noData
        case failedFetch
        case otherError
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    var users = [User]()
    let lockForUsers = NSLock()
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=50")!
    
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                NSLog("Failed fetching users with error: \(error)")
                return completion(.failure(.failedFetch))
            }
            
            guard let data = data else {
                NSLog("Fetch returned with no data.")
                return completion(.failure(.noData))
            }
            
            do {
                let users = try JSONDecoder().decode(Results.self, from: data)
                self.lockForUsers.lock()
                self.users.append(contentsOf: users.results)
                completion(.success(true))
                self.lockForUsers.unlock()
            } catch {
                NSLog("Failed to decode data.")
                return completion(.failure(.otherError))
            }
        }
        .resume()
    }
}
