//
//  UserController.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation

class UserController {
    
    let baseURL = URL(string:"https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    var results: Results?
    var users: [User] = []
    
    func turnResultsIntoUsers(results: Results) -> [User] {
        return results.results
    }
    
    func fetchUsers(completion: @escaping (Error?) -> Void =  { _ in }) {
        let request = URLRequest(url: baseURL)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("Error with data")
                completion(error)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let receivedUsers = try jsonDecoder.decode(Results.self, from: data)
                self.results = receivedUsers
            } catch {
                NSLog("Error decoding Results: \(error)")
                completion(error)
                return
            }
            self.users = self.turnResultsIntoUsers(results: self.results!)
            completion(nil)
        }.resume()
    }
    
}
