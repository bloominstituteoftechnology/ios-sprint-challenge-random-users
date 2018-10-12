//
//  UserController.swift
//  Random Users
//
//  Created by Madison Waters on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController {
    
    private(set) var users: [User] = []
    
    func fetchUsers(completion: @escaping ([User], Error?) -> ()) {
            let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
            URLSession.shared.dataTask(with: url) {data, _, error in
                var users = [User]()
                
                guard let data = data else {
                completion(users, NSError())
                return
                }
                
                do {
                    self.users = try JSONDecoder().decode([String: User].self, from: data).map() { $0.value}
                    completion(users, error)
                    return
                    
                } catch {
                    NSLog("Unable to decode user data: \(error)")
                    completion(users, NSError())
                    return
                }
            }
            .resume()
    }
}
