//
//  RandomUsersController.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
class RandomUsersController {

    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchUsers(completion: @escaping (RandomUsers?, Error?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError())
                return
            }

            do {
                let randomUsers = try JSONDecoder().decode(RandomUsers.self, from: data)
                completion(randomUsers, nil)
            } catch {
                completion(nil, error)
                return
            }
            }.resume()
    }
}
