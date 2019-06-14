//
//  UsersController.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers() -> Users? {
        do {
            
            let userData = try Data(contentsOf: baseURL)
            let users = try JSONDecoder().decode(Users.self, from: userData)
            return users
            
        } catch {
            NSLog("Error Decoding: \(error)")
        }
        return nil
    }
}
