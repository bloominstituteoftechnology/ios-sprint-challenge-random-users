//
//  NetworkController.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class NetworkController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void = {_ in }) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let formatItem = URLQueryItem(name: "format", value: "json")
        let incItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsItem = URLQueryItem(name: "results", value: "1000")
        
        urlComponents?.queryItems = [formatItem, incItem, resultsItem]
        
        guard let url = urlComponents?.url else {
            NSLog("No URL")
            completion(NSError())
            return
        }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error connnecting to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Data could not be fetched.")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedUsers = try decoder.decode(Results.self, from: data)
                self.users = decodedUsers.results
            } catch {
                NSLog("Error decoding data.")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
