//
//  UserClient.swift
//  Random Users
//
//  Created by ronald huston jr on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("error getting users: \(error)")
            }
            
            guard let data = data else {
                NSLog("no data returned from fetch")
                completion(nil, error)
                return
            }
            
            do {
                let fetch = try JSONDecoder().decode(UserResult.self, from: data)
                let users = fetch.users
                completion(users, nil)
                return
            } catch {
                NSLog("error decoding users: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}
