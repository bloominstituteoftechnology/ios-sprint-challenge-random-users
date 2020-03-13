//
//  UserController.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [Result] = []
    
    var addUsers: Bool = false
    
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
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
