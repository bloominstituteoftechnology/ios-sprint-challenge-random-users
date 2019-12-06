//
//  UserClient.swift
//  Random Users
//
//  Created by Jonalynn Masters on 12/6/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation

class UserClient {
    let userURL = URL(string: "https://randomuser.me/api/?results=3000&nat=us&inc=name,email,phone,picture")!
    var users: [User] = []
    var imageData: Data?

    func fetchUsers(completion: @escaping(Error?) -> Void) {
        URLSession.shared.dataTask(with: userURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                completion(error)
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let resultData = try jsonDecoder.decode(UserResults.self, from: data)
                self.users = resultData.results
            } catch {
                NSLog("Error decoding users \(error)")
            }
            completion(nil)
        }.resume()
    }
}
