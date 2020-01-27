//
//  UserController.swift
//  Random Users
//
//  Created by Christy Hicks on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit
// MARK: Enums
enum NetworkError: Error {
    case otherError
    case badData
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "POST"
    case delete = "DELETE"
}

let baseURL = URL(string: "https://randomuser.me/api/")!

class UserController {
    // MARK: Properties
    private (set) var users: [User] = []
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: Methods
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let includeQuery = URLQueryItem(name: "inc", value: "name, email, phone, picture")
        let resultsQuery = URLQueryItem(name: "results", value: "5000")
        
        urlComponents?.queryItems = [jsonQueryItem, includeQuery, resultsQuery]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("Error: Request URL is nil")
            completion(NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error retrieving users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                let contactResults = try JSONDecoder().decode(Users.self, from: data)
                self.users = contactResults.results
                completion(nil)
            } catch {
                NSLog("Error decoding contacts: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
