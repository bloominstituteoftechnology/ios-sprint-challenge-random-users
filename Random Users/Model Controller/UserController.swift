//
//  UserController.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
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

class UserController {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    typealias CompletionHandler = (Result<[User], NetworkError>) -> Void
    
    func fetchRandomUsers(completion: @escaping CompletionHandler) {
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                NSLog("Error in getting the users: \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            guard let data = data else {
                NSLog("Error in fetching data: \(error)")
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let randomUsers = try decoder.decode(UserResult.self, from: data).results
                completion(.success(randomUsers))
            } catch {
                completion(.failure(.noDecode))
            }
        }.resume()
    }
}
