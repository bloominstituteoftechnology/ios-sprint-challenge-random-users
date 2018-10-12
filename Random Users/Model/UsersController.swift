//
//  UsersController.swift
//  ContactManager
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

class UsersController {
    
    func getUsers() -> Users? {
        
        let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        
        do{
            let usersData = try Data(contentsOf: baseURL)
            let jsonDecoder = JSONDecoder()
            
            let users = try jsonDecoder.decode(Users.self, from: usersData)
            print("Success Decoding")
            return users
        } catch {
            NSLog("Error Decoding: \(error)")
        }
        return nil
        
    }
    
}
