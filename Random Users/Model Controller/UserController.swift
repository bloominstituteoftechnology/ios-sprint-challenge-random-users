//
//  UserController.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    
    let url = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    
    // MARK: - Fetch random users
    
    func fetchRandomUsers(completion: @escaping ([User]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                NSLog("Error fetching users")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(nil, error)
                return
            }
            
            do {
                let users = try JSONDecoder().decode(Results.self, from: data)
                let randomUsers = users.results
                completion(randomUsers, nil)
                return
            } catch {
                NSLog("Error decoding users: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}
