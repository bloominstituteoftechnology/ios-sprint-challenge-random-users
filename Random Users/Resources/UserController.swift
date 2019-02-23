//
//  UserController.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=50")!
    
    func getUsers(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
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
                let decodedDict = try jsonDecoder.decode([String: User].self, from: data)
                let users = Array(decodedDict.values)
                print(users)
                //self.users = users
                completion(nil)
            } catch {
                print("Error decoding received data: \(error)")
                completion(error)
                return
            }
            
            }.resume()
        
    }
    
   /* func testEncodingExampleAlbum() {
        let jsonURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=50")!
        let data = try! Data(contentsOf: jsonURL)
        
        var user: User?
        
        let jsonDecoder = JSONDecoder()
        
        do {
            user = try jsonDecoder.decode(User.self, from: data)
            print("Decoded: \(user!)")
        } catch {
            NSLog("\(error)")
        }
        
    }*/

    
    
    
}

