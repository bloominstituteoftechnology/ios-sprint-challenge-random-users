
//
//  APIClient.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 12/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersApiController {
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    enum NetworkError: Error {
        case noData
        case badData
        case noAuth
        case badAuth
        case otherError
        case noDecode
        case badImage
    }
    
    // MARK: - Properties -
    
    var users: [User] = []
    private let baseURL = URL(string: "https://randomuser.me/api/?results=1000")!
    private lazy var jsonDecoder = JSONDecoder()
    
    func fetchUserDetails(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let userURL = baseURL
        var request = URLRequest(url: userURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving user details \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                self.users = try Array(self.jsonDecoder.decode(Results.self, from: data).results)
                print(self.users.count)
                completion(.success(self.users))
            } catch {
                print("Error decoding user details object: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }
    
}
