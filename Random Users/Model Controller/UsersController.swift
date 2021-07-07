//
//  UsersController.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    var users: [Users] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!.usingHTTPS!
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        
        let request = baseUrl
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching the users with error: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned from the data task")
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedUsers = try decoder.decode(UserResults.self, from: data)
                self.users = decodedUsers.results
                completion(nil)
                
            } catch {
                print("Error getting data with error: \(error)")
                completion(error)
            }
            
            }.resume()
    }
}
