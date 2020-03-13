//
//  UserController.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    
    func fetchUsers(completion: @escaping ( [User]?,Error?) -> Void ) {
        var requestURL = URLRequest(url: baseURL)
        
        requestURL.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
             print(error)
                completion(nil,error)
                return
            }
            
            guard let data = data else {
                NSLog("No data from server")
                completion(nil,NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedUsers = try jsonDecoder.decode(Results.self, from: data)
                self.users = decodedUsers.users
                completion(self.users,nil)
            } catch  let err as NSError {
            print(err)
                return
            }
     
        }.resume()

        
    }
    
}



































