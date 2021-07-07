//
//  UserClient.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {

static let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {

        let url = UserClient.baseURL

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users from data task: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                NSLog("Bad data")
                completion(nil, NSError())
                return
            }

            let decoder = JSONDecoder()

            do {
                let results = try decoder.decode(Result.self, from: data)
                let users = results.results
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
