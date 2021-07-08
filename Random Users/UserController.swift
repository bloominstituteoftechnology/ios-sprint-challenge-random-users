//
//  UserController.swift
//  Random Users
//
//  Created by Sean Hendrix on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    func getUsersFromAPI(completion: @escaping CompletionHandler = { _ in }) {
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        let resultCountQueryItem = URLQueryItem(name: "results", value: "1000")
        let nationalityQueryItem = URLQueryItem(name: "nat", value: "us,fr,gb,au")
        let excludingQueryItem = URLQueryItem(name: "exc", value: "location,login,registered,id,nat")
        let noInfoQueryItem = URLQueryItem(name: "noinfo", value: nil)
        let queryItems = [resultCountQueryItem, nationalityQueryItem, excludingQueryItem, noInfoQueryItem]
        components?.queryItems = queryItems
        
        guard let requestUrl = components?.url else {
            NSLog("Error creating request url")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let _ = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error received from data task: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned from the data task.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let userResults = try jsonDecoder.decode(Users.self, from: data)
                self.users = userResults.results
                
                completion(nil)
                
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
            
            }.resume()
    }
    
    private(set) var users: [User] = []
    let baseUrl = URL(string: "https://randomuser.me/api/")!
    
    typealias CompletionHandler = (Error?) -> Void
}
