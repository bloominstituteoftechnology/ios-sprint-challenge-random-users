//
//  UserController.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

class UserController {
    
    // MARK: - Variables
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=5000")!
    var users: [User] = []
    var largeImageData: Data?
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchUser(completion: @escaping CompletionHandler = { _ in }) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error retrieving users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data")
                completion(error)
                return
            }
            
            do {
                let fetchedUsers = try JSONDecoder().decode(Results.self, from: data)
                for result in fetchedUsers.results {
                    self.users.append(result)
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                NSLog("Error decoding users from server: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func fetchLargeImage(user: User, completion: @escaping CompletionHandler = { _ in }) {
        let largeURL = user.largeImage
        let request = URLRequest(url: largeURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching large image: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data")
                completion(error)
                return
            }
            self.largeImageData = data
        }.resume()
    }
}
