//
//  UserClient.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class UserClient {

    let baseURL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!


    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("error")
                NSLog("Error getting users: \(error)")
            }
            guard let data = data else {
                print("error")
                NSLog("No data returned from data task.")
                completion(nil, error)
                return
            }

            do {
                let newUsers = try JSONDecoder().decode(UserResult.self, from: data)
                let users = newUsers.users
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
