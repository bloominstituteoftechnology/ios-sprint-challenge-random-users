//
//  UsersController.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// Model Controller
//base URL
private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000" )!

class UsersController {
    
    //Properties
    var users: [User] = []
    
    // fetching data
    func fetchUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        
        
        let dataTask = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching user data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching user data: \(String(describing: error))")
                completion(error)
                return
            }
            
            // Do | Catch block
            do {
                let jsonDecoder = JSONDecoder()
                let randomUser = try jsonDecoder.decode(Users.self, from: data)
                self.users = randomUser.results
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(nil)
                return
            }
        }
        
        dataTask.resume()
        
    }
    
    
}
