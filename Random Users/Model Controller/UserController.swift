//
//  UserController.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users = [User]()
    
    static let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        
        // don't need this because the baseURL is already complete
//        let url = UserController.baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: UserController.baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error retrieving data from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(UserResults.self, from: data)
                let userResult = results.results
                
                DispatchQueue.main.async {
                    self.users = userResult
                    completion(nil)
                }
                
            } catch {
                NSLog("Error decoding received data: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
}
