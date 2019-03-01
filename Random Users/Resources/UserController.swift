//
//  UserController.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [Result] = []
    
    var addUsers: Bool = false
    
    // To see my addUsers function work, change the url to fetch 5 users and then press 'add' to see the added users easier.
    
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=300")!
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedObj = try jsonDecoder.decode(UserResults.self, from: data)
              //  print(decodedObj)
                if self.addUsers == false {
                    self.users = decodedObj.results
                } else {
                    self.users.append(contentsOf: decodedObj.results)
                }
                completion(nil)
            } catch {
                print("Error decoding received data: \(error)")
                completion(error)
                return
            }
            
            }.resume()
        
    }
    
}

