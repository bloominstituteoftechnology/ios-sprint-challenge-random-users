//
//  UserController.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    var addUsers = false
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedUsers = try decoder.decode(FetchResults.self, from: data)
                if self.addUsers == false {
                    self.users = decodedUsers.results
                } else {
                    self.users.append(contentsOf: decodedUsers.results)
                }
                completion(nil)
            } catch {
                NSLog("Decoding Error: \(error)")
                completion(error)
                return
            }
            }.resume()
    }
}
