//
//  UserController.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

class UserController {
    
    var users = [User]()

    
    func loadUsers(_ completion: @escaping (String?) -> Void)
    {
        users = [User()]
        
        let baseURL = URL(string:"https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                NSLog("There was an error \(error)");
                completion("There was an error")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data")
                completion("No data")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(User.Results.self, from: data)
                self.users = results.results
                completion(nil)
                return
            } catch {
                NSLog("Error decoding json: \(error)")
                NSLog(String(data:data, encoding:.utf8) ?? "Couldn't encode json as utf8")
                completion("Couldn't decode json")
                return
            }
            }.resume()
    }
}

