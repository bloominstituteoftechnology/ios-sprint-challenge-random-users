//
//  RandomUserController.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    // MARK: - URL Session
    func fetchRandomUsers(completion: @escaping ([RandomUser]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: RandomUserController.baseURL) { (data, _, error) in
            
            // Check for errors
            if let error = error {
                NSLog("Error fetching random users from API: \(error)")
                completion(nil, error)
                return
            }
            
            // Unwrap data
            guard let data = data else {
                NSLog("No data found.")
                completion(nil, NSError())
                return
            }
            
            // Data downloaded, decode it
            do {
                let users = try JSONDecoder().decode(RandomUsers.self, from: data)
                let randomUsers = users.randomUsers
                completion(randomUsers, nil)
                return
            } catch {
                NSLog("I have an error in my user decoder: \(error)")
                completion(nil, error)
                return
            }
        }
    }
    
    // MARK: - Properties
     static let baseURL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
