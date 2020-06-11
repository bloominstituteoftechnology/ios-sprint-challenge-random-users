//
//  UserClient.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=3000")!
    
    var users: [User] = []
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task: \(String(describing: error))")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UserResults.self, from: data).results
                self.users = result
            } catch {
                NSLog("Error decoding Users: \(error)")
            }
            completion(nil)
        }.resume()
    }
}
