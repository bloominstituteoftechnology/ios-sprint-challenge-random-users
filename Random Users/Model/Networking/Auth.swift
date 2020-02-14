//
//  Auth.swift
//  Random Users
//
//  Created by Aaron Cleveland on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case otherError
    case badData
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "POST"
    case delete = "DELETE"
}

// Alt Option: let baseURL = URL(string: "https://randomuser.me/api/")!
let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
typealias CompletionHandler = (Error?) -> Void

class Auth {
    private (set) var users: [User] = []
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        /* Part of Alt Option // IF you want to have a little more control of the URLQueryItem
         
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let includeQuery = URLQueryItem(name: "inc", value: "name, email, phone, picture")
        let resultsQuery = URLQueryItem(name: "results", value: "1000")

        urlComponents?.queryItems = [jsonQueryItem, includeQuery, resultsQuery]

        guard let requestURL = urlComponents?.url else {
            NSLog("Error: Request URL is nil")
            completion(NSError())
            return
        }
        */
        
        var request = URLRequest(url: baseURL)
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
            DispatchQueue.main.async {
                do {
                    let userResults = try JSONDecoder().decode(Users.self, from: data)
                    let results = userResults.results.sorted(by: {$0.name < $1.name})
                    self.users = results
                    completion(nil)
                } catch {
                    NSLog("Error decoding contacts: \(error)")
                    completion(error)
                    return
                }
            }
        }.resume()
    }
}
