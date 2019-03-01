//
//  NetworkController.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class NetworkController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error connnecting to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Data could not be fetched.")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedUsers = try decoder.decode([User].self, from: data)
                self.users = decodedUsers
            } catch {
                NSLog("Error decoding data.")
                completion(NSError())
                return
            }
            completion(nil)
        }.resume()
    }
}
