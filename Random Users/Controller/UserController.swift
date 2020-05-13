//
//  APIController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case badURL
    case badData
    case noDecode
    case failedFetch
}

class UserController {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        
    func fetchRandomUser(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                NSLog("Error getting users: \(error)")
                completion(.failure(.failedFetch))
                return
            }
            
            guard let data = data else {
                NSLog("Error returned from data.")
                completion(.failure(.badData))
                return
            }
            
            do {
                let decoder = try JSONDecoder().decode(Results.self, from: data)
                let users = decoder.results
                completion(.success(users))
                return
            } catch {
                NSLog("Error decoding User objects: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
}
