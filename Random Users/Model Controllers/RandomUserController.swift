//
//  RandomUserController.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserController {
    
    func fetchRandomUsers(completion: @escaping ([RandomUser]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: RandomUserController.baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching random users: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data found.")
                completion(nil, NSError())
                return
            }
            
            do {
                let users = try JSONDecoder().decode(RandomUsers.self, from: data)
                let randomUsers = users.randomUsers
                completion(randomUsers, nil)
                return
            }
            catch {
                NSLog("Error decoding users: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    static let baseURL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
