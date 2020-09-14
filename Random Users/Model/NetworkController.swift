//
//  NetworkController.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

final class NetworkController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noData
        case noDecode
        case failedDecoding
        case otherError
        
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    private (set) var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                print("Error \(error)")
                completion(.failure(.noDecode))
                return
            }
            
            guard let data = data else {return}
            
            do {
                let decoder = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = decoder.results
                completion(.success(true))
                print(self.users)
            } catch {
                print("Error \(error)")
                completion(.failure(.failedDecoding))
            }
        }
        task.resume()
    }
}

