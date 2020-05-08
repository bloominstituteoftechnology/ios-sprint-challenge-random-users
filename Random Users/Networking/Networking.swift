//
//  Networking.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Networking {
    
    let usersURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=3")! // FIXME: - update this to 1000 after it works
    var users = [Result]()
    
    func fetchUsers(completion: @escaping () -> Void) {
        URLSession.shared.dataTask(with: usersURL) { (data, urlResponse, error) in
            if let error = error { print(error) }
            if let data = data {
                do {
                    let fetchedUsers = try JSONDecoder().decode(User.self, from: data)
                    self.users.append(contentsOf: fetchedUsers.results)
                    print(fetchedUsers)
                    completion()
                } catch {
                    print(error)
                    completion()
                }
            }
        }.resume()
    }
    
}
