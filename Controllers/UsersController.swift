//
//  UsersController.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    // Using this initializer as the "viewDidLoad" of the VC
    init() {
        fetchUsers()
    }
    
    // Fetch Users
    
    func fetchUsers(completion: @escaping () -> Void = { }) {
        
//        var components = URLComponents()
//
//        components.queryItems = [
//            URLQueryItem(name: "name", value: query) // One name, user
//
//        ]
        
        
        
        // Set up the URL
        
        let requestURL = baseURL
            .appendingPathExtension("?format=json&inc=name,email,phone,picture&results=1000")
//            .appendingPathExtension("?format=json&inc=name,picture&results=1000")

        
        
        // Create the URLRequest
        
        var request = URLRequest(url: requestURL)
        
        // Perform the data task
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
        
            
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from users fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let users = try decoder.decode(Users.self, from: data)
                
//                let users = try decoder.decode(String: Users.self, from: data).map({ $0.value })
                            
            } catch {
                NSLog("Error decoding users: \(error)")
            }
            
            completion()
            
        }.resume()
    }
}

enum HTTPMethod: String {
     case get = "GET"
     case put = "PUT"
     case post = "POST"
     case delete = "DELETE"
 }
