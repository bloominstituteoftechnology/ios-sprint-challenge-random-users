//
//  UserController.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    //MARK: Properties
    
    var users: [User] = []
    
    let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    //MARK: Networking
    
    struct Results: Decodable {
        var results: [User]
    }
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        print("About to start data task.")
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            print("Data task complete.")
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned fetching users.")
                completion(NSError())
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                
                self.users.append(contentsOf: results.results)
                completion(nil)
            } catch {
                NSLog("Error decoding users: \(error)")
                completion(error)
            }
        }.resume()
    }
}
