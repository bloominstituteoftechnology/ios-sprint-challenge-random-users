//
//  APIController.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case noData
    case failedDecode
    case failedEncode
    case otherError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIController {
    let baseURL = URL(string: "https://randomuser.me")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    typealias CompletionHandler = (Result<UserResults, NetworkError>) -> Void
    
    var userResults: UserResults?
    
    func getUsersFromAPI(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = URL(string: "/api/?format=json&inc=name,email,phone,picture&results=1000", relativeTo: baseURL)!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from API (fetching users).")
                completion(.failure(.noData))
                return
            }
            
            do {
                let results = try self.decoder.decode(UserResults.self, from: data)
                self.userResults = results
                completion(.success(results))
            } catch {
                NSLog("Error decoding JSON data: \(error)")
            }
        }.resume()
    }
}
