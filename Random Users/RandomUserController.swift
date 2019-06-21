//
//  RandomUserController.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    private(set) var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        let requestURL = baseURL
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            do {
                let randomUsers = try JSONDecoder().decode(Users.self, from: data)
                self.users = randomUsers.results
                print(self.users)
                completion(nil)
            } catch {
                NSLog("Unable to decode user data from JSON: \(error)")
                completion(error)
                return
            }
        }.resume()

    }
    
}
