//
//  UserClient.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class UserClient {

    var users: [User] = []

    let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=1000")!
    
    typealias CompletionHandler = (Error?) -> Void

    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("error")
                NSLog("Error getting users: \(error)")
            }
            guard let data = data else {
                print("error")
                NSLog("No data returned from data task.")
                completion(nil)
                return
            }

            do {
                let newUsers = try JSONDecoder().decode(UserResult.self, from: data)
                self.users = newUsers.results
            } catch {
                NSLog("Error decoding users: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
    }

}
