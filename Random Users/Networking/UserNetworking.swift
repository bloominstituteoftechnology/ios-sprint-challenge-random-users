//
//  UserNetworking.swift
//  Random Users
//
//  Created by Nikita Thomas on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserNetworking {
    
    static let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: UserNetworking.baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            
            do {
                let userData = try JSONDecoder().decode(Users.self, from: data)
                let users = userData.users
                completion(users, nil)
                return
            } catch {
                NSLog("Error decoding: \(error)")
                completion(nil, error)
                return
            }
            }.resume()
    }
}
