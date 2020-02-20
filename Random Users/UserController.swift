//
//  UserController.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// should be 1000 instead of 1 !!!
let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    /// Array that stores users
    var users: [User] = []
    
    init() {
        print("init")
    }
    
    /// Fetch (at least 1000) random users from baseURL
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let error = error {
                print("Error in datatask in fetchUsers: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data in UserController")
                completion(error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let fetchedUsers = try decoder.decode(UserResults.self, from: data)
                self.users = fetchedUsers.results
                completion(nil)
            } catch {
                print("Error decoding users: \(error)")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}
