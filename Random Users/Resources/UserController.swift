//
//  UserController.swift
//  Random Users
//
//  Created by Moses Robinson on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

let baseURL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController {
    
    func loadUsers(completion: @escaping ([User]?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching random users: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data found.")
                completion(nil, NSError())
                return
            }
            
            do {
                let usersDecoded = try JSONDecoder().decode(Users.self, from: data)
                let users = usersDecoded.users
                completion(users, nil)
                return
            }
            catch {
                NSLog("Error decoding users: \(error)")
                completion(nil, error)
                return
            }
            }.resume()
    }
}
