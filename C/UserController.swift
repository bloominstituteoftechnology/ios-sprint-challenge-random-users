//
//  UserController.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    var shouldAddUsers: Bool = false
    
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedUsers = try jsonDecoder.decode(UserResults.self, from: data)
                if self.shouldAddUsers == false {
                    self.users = decodedUsers.results
                } else {
                    self.users.append(contentsOf: decodedUsers.results)
                }
                completion(nil)
            } catch {
                print("Error decoding data: \(error)")
                completion(error)
                return
            }
            
            }.resume()
    }
}
