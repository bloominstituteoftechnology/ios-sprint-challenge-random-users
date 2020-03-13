//
//  UserNetworkController.swift
//  Random Users
//
//  Created by Joseph Rogers on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    var users: [User]
    
    init() {
        users = []
//        fetchUsers()
    }
    
    func fetchUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "randomuser.me"
        components.path = "/api"
        
        let queryItemFormat = URLQueryItem(name: "format", value: "json")
        let queryItemInc = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let queryItemResults = URLQueryItem(name: "results", value: "1000")
        components.queryItems = [queryItemFormat, queryItemInc, queryItemResults]
        
        guard let url = components.url else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Data task error: \(error)")
                completion(error)
                return
            }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(Results.self, from: data)
                self.users = results.users
            } catch {
                print("Error decoding array of users: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }
}
