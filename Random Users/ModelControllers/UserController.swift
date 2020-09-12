//
//  UserController.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum NetworkError: Error {
        case noData
        case decodeFailure
        case tryAgain
    }
    
    // MARK: - Public Properties
        
    private(set) var users: [User] = []
    
    // MARK: - Private Properties
        
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    // MARK: - Functions
    
    func fetchUsers(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            guard let data = data else {
                print("Error: no data")
                completion(.failure(.noData))
                return
            }
            
            do {
                let userResults = try JSONDecoder().decode(UserResults.self, from: data)
                self.users.append(contentsOf: userResults.results)
                completion(.success(true))
            } catch {
                print("Error decoding users: \(error)")
                completion(.failure(.decodeFailure))
                return
            }
        }.resume()
    }
    
}
