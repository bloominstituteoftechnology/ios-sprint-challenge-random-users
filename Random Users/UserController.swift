//
//  UserController.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation


class UserController {
    let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    var users: [User] = []
    
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        let requestUrl = baseUrl
        
        URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in
            if let error = error {
                NSLog("Error getting Users \(error)")
                completion(error)
                return
            }
            
            guard let data =  data else {
                NSLog("Error returning data \(error)")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.users = try decoder.decode(Users.self, from: data).users
                completion(nil)
            } catch {
                NSLog("Error decoding random users JSON \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    
}
