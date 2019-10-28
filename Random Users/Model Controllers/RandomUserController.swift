//
//  RandomUserController.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - BaseURL
private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=5000")!

class RandomUserController {
    
    // MARK: - Properties
    var randomUsers: [RandomUser] = []
    
    // MARK: - Fetch Method
    func fetchRandomUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error starting data task: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error finding data.")
                completion(error)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedUsers = try jsonDecoder.decode(RandomUsers.self, from: data)
                self.randomUsers = decodedUsers.results
                completion(nil)
            } catch {
                NSLog("Error trying to decode random users: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
