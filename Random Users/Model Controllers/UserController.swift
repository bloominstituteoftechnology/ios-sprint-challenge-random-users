//
//  UserController.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    var users: [User] = []
    
    func fetchUsers() {
        let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=10&noinfo")!
        
        do {
            let data = try Data(contentsOf: baseURL)
            let people = try JSONDecoder().decode(Results.self, from: data)
            users = people.results
        } catch {
            print("Error fetching poeple: \(error)")
        }
    }
}
