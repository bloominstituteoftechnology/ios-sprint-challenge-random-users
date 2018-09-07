//
//  UserController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    func getUsers(completion: @escaping (Error?) -> Void) {
        let url = UserController.baseURL
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser data: \(error) - \(url)")
                completion(error)
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let randomUserJSON = try decoder.decode(Results.self, from: data)
        
                self.users = randomUserJSON.results.compactMap { $0 }
            } catch let error {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    var users: [User] = []
    static var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
