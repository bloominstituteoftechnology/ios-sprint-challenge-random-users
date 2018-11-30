//
//  FetchUsers.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchRandomUsersController {
    static let url = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1050")!
    
    func fetchUsers(completion: @escaping ([RandomUser]?, Error?)-> Void ) {
        URLSession.shared.dataTask(with: FetchRandomUsersController.url) { (data, _, error) in
            if let error = error {
     NSLog("failed fetching users\(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("no data")
                completion(nil, NSError())
            return
        }
        
            do {
                let user = try JSONDecoder().decode(RandomUsers.self, from: data)
                let ranUsers = user.randomUsers
                completion(ranUsers, error)
                return

            } catch {
                
                NSLog("error\(error)")
                completion(nil, error)
                return
            }
    
        }.resume()
    
        }
  
}
