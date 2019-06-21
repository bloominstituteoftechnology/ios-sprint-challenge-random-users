//
//  UserController.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        URLSession.shared.dataTask(with: baseURL) { (data,_ , error) in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)   // is this correct? array of users
                
                // completion can ALSO be used to send users to the calling location so long as we use @escaping, but how do we want the data to get to TableViewController given our potential problems with loading Image data?  We will need to download image data using the url separately-- inside the TableView
                self.users = users
                
                completion(nil)
            } catch {
                print(error)
                completion(error)
            }
            
        }.resume()
    } // end getUsers
    
    var users = [User]()
}
