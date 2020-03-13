//
//  UserController.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class UserController {
    var userList: [User] = []
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=1000")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching user list")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let user = try JSONDecoder().decode(UserResults.self, from: data)
                    self.userList = user.results
                } catch {
                    NSLog("Error decoding user list")
                    completion(nil)
                    return
                }
                completion(nil)
            }
        }.resume()
    }
    
    
}
