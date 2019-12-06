//
//  UserController.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    
    var users: [User] = []
    
    // MARK: - Methods
    
    func fetchUsers() {
        let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=1000&noinfo")!
        
        do {
            let data = try Data(contentsOf: baseURL)
            let people = try JSONDecoder().decode(Results.self, from: data)
            users.append(contentsOf: people.results)
            
            let userNames = users.compactMap { $0.name }
            let userLastNames: [String] = userNames.compactMap {
                var lastName: String
                let firstLast = $0.split(separator: " ")
                if let last = firstLast.last {
                    lastName = String(last)
                    return lastName
                }
                return ""
            }
            let userDict = zip(userLastNames, users)
            let sortedUserDict = userDict.sorted { $0.0 < $1.0 }
            users = sortedUserDict.compactMap { $0.1 }
            print(users.count)
        } catch {
            print("Error fetching poeple: \(error)")
        }
    }
}
