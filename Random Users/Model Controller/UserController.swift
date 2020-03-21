//
//  UserController.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    var users: [User] = []
    
    func fetchUsers() {
        let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: baseURL)
            let contacts = try decoder.decode(Results.self, from: data)
            users = contacts.results
        } catch {
            print("Error fetching Results: \(error)")
        }
    }
}
