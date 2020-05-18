//
//  UserController.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noIdentifier
        case otherError
        case noData
        case noDecode
        case noEncode
        case noRep
    }
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=10")!
    
    var results: Results?
    
    func fetchUsers(completion: @escaping (Result<Results, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error completing dataTask: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("Error returning data")
                completion(.failure(.noData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                self.results = try jsonDecoder.decode(Results.self, from: data)
                completion(.success(self.results!))
            } catch {
                NSLog("Error: unable to decode data: \(error)")
            }
        }.resume()
    }
    
}
