//
//  RandomUserController.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherNetworkError
    case badData
    case noDecode
    case badUrl
}

class RandomUserController {

    private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchRandomUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {

        let randomUsersUrl = baseUrl
        
        var request = URLRequest(url: randomUsersUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error receiving user data: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                // User is not authorize (no token or bad token)
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let users = try decoder.decode(UsersFromServer.self, from: data).results
                completion(.success(users))
            } catch {
                completion(.failure(.noDecode))
            }
            
        }.resume()
    }
}
