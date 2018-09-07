//
//  UserController.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {
    
    static let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: UserClient.baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else { completion(nil, NSError()); return }
            
            do {
                let usersModel = try JSONDecoder().decode(Users.self, from: data)
                let users = usersModel.users
                completion(users, nil)
                return
            } catch {
                NSLog("Error decoding users: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}
