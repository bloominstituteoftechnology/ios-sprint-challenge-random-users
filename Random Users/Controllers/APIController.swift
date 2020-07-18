//
//  APIController.swift
//  Random Users
//
//  Created by Rob Vance on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class RandomUsersApiController {
    // Properties
    var users: [User] = []
    private let baseURL = URL(string: " https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    private lazy var jsonDecoder = JSONDecoder()
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    enum NetworkError: Error {
        case badData
        case noData
        case noAuth
        case otherError
        case noDecode
        case badImage
    }
    
    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let error = error {
                completion(.failure(.otherError))
                print("error receiving user details\(error)")
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.failure(.noAuth))
            }
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                self.users = try Array(self.jsonDecoder.decode(Results.self, from: data).results)
                completion(.success(self.users))
            } catch {
                print("Error decoding user details: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
}
