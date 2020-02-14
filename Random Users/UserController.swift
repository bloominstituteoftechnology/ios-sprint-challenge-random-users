//
//  UserController.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // should be 1000 instead of 1
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1")!
    
    typealias CompletionHandler = (Error?) -> Void
    /// Array that stores users
    var userArray: [User] = []
    
    init() {
        print("init")
        getUsers()
    }
    
    /// Fetches users from API (decoding them) and appends them to self.userArray
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        print("called getUsers")
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error occured in getUsers: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let userResults = try decoder.decode(UserResults.self, from: data)
                self.userArray = userResults.results
                print(self.userArray)
                //self.userArray.append(userResults)
                DispatchQueue.main.async {
                    completion(nil)
                }
                //completion(nil)
            } catch {
                print("Error decoding users in getUsers: \(error)")
                completion(nil)
            }
            
        }.resume()
    }
}
