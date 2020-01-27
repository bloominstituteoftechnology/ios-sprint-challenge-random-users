//
//  UserController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    var friends: [Friend] = []
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    func fetchUsers() {
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "GET"
        
        let fetchUsersTask = URLSession.shared.dataTask(with: request) { (possibleData, _, possibleError) in
            // TODO: Include defer when code moved to Operation class
            
            if possibleError != nil {
                print("Error in retrieving data from fetchUsers task: \(possibleError!)")
                return
            }
            
            guard let data = possibleData else {
                print("Bad data returned in fetchUsers task: \(possibleError!)")
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedUsers = try decoder.decode([Friend].self, from: data)
                self.friends = decodedUsers
            } catch {
                print("Error decoding users: \(possibleError)")
                return
            }
        }
        fetchUsersTask.resume()
    }
}
