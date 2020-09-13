//
//  APIController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error{
    case noAuth
    case badAuth
    case decodeFailed
    case noImage
    case noConnection
    case badURL
    case otherNetworkError
    case noDecode
    case badData
}

class APIController {
    
     private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

        func fetchRandomUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {

            let randomUserURL = baseURL

            var request = URLRequest(url: randomUserURL)
            request.httpMethod = HTTPMethod.get.rawValue

            /// Actual API Request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error with API call... \(error)")
                    completion(.failure(.otherNetworkError))
                    return
                }

                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(.failure(.badAuth))
                    return
                }

                guard let data = data else {
                    completion(.failure(.noConnection))
                    return
                }

                let decoder = JSONDecoder()

                do {
                    let users = try decoder.decode(APIResults.self, from: data).results
                    completion(.success(users))
                } catch {
                    completion(.failure(.noDecode))
                }

            }.resume()
        }
    }
