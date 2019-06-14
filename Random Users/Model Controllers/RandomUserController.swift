//
//  RandomUserController.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - BaseURL
private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture")!

class RandomUserController {
    
    // MARK: - Properties
    var randomUsers: [RandomUser] = []
    
    // MARK: - Fetch Method
    func fetchRandomUsers(results: String, completion: @escaping (Error?) -> Void = { _ in }) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "results", value: results)
        urlComponents?.queryItems = [queryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("Error creating request url.")
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error starting data task: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error finding data.")
                completion(error)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedUsers = try jsonDecoder.decode(RandomUsers.self, from: data)
                self.randomUsers = decodedUsers.results
                completion(nil)
            } catch {
                NSLog("Error trying to decode random users: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
