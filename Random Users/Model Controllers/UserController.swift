//
//  UserController.swift
//  Random Users
//
//  Created by Wyatt Harrell on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class UserController {
    
    var users: [Result] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        let requestURL = URLRequest(url: baseURL)

        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                let users = try JSONDecoder().decode(Users.self, from: data).results
                self.users = users
                completion(nil)
            } catch {
                NSLog("Error decoding or saving data: \(error)")
                completion(error)
            }
            
            
            
        }.resume()
    }
    
    
    
}
