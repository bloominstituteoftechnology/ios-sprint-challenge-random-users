//
//  RandomUsersClient.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//


import UIKit

enum HTTPMethod: String {
    case get = "GET"
}

class RandomUsersClient {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,dob,picture&noinfo&results=1000")!
    
    var savedUsers: [User] = []
    
    func fetchRandomUser(completion: @escaping (Error?) -> Void) {
        
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error with data")
                completion(error)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(RandomUsers.self, from: data)
                self.savedUsers = result.results
            } catch {
                NSLog("Error decoding users: \(error)")
            }
            completion(nil)
        }.resume()
    }
}
