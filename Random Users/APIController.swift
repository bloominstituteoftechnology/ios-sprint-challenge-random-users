//
//  APIController.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

final class APIController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, noURL, decodingError
    }
    
    var user: [User] = []
    private let baseURL = URL(string: "https://randomuser.me/api")!
    
    
    func fetchUsers(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let queryItrem = URLQueryItem(name: "inc", value: "name, email, phone, picture")
        let queryItem1 = URLQueryItem(name: "results", value: "500")
        
        urlComponents?.queryItems = [jsonQueryItem, queryItrem, queryItem1]
        
        guard let requestURL = urlComponents?.url else {
            print("Error getting request url")
            completion(.failure(.noURL))
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error getting users: \(error)")
                completion(.failure(.noData))
                return
            }
            
            guard let data = data else {
                print("Error getting data: \(String(describing: error))")
                completion(.failure(.noData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Users.self, from: data)
                self.user = results.results
                completion(.success(true))
            } catch {
                NSLog("Error decoding results: \(error)")
                completion(.failure(.decodingError))
            }
        } .resume()
    }
    
}


