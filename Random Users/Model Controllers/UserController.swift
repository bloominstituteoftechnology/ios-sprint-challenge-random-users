//
//  UserController.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    var users: [User] = []
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
        
            if let error = error {
                NSLog("Error fetching users from data task.")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task.")
                completion(NSError())
                return
            }
            
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                self.users = userResult.results
                completion(nil)
            } catch {
                print(error)
                completion(error)
            }
        }.resume()
    }
}
