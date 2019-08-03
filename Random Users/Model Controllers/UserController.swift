//
//  UserController.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

let baseURL = URL(string: "https://randomuser.me/api/")!

class UserController {
    typealias CompletionHandler = (Error?) -> Void
    
    private (set) var users: [User] = []
        
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let incQueryItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsQueryItem = URLQueryItem(name: "results", value: "1000")
        
        urlComponents?.queryItems = [jsonQueryItem, incQueryItem, resultsQueryItem]
        
        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(NSError()); return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedDictionary = try jsonDecoder.decode([String: User].self, from: data)
                let users = Array(decodedDictionary.values)
                self.users = users
                completion(nil)
            } catch {
                NSLog("Unable to decode data into object of type [User]: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
