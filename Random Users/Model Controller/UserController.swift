//
//  UserController.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class UserController {
    
    // MARK: - Properties
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var users: [User] = []
    
    // MARK: - CRUD Methods
    
    func createUser(firstName: String,
                    lastName: String,
                    thumbnail: URL,
                    largePhoto: URL,
                    phoneNumber: String,
                    emailAddress: String) {
        
       let newUser = User(firstName: firstName,
                          lastName: lastName,
                          email: emailAddress,
                          phoneNumber: phoneNumber,
                          thumbnail: thumbnail,
                          largePhoto: largePhoto)
        users.append(newUser)
    }
    
}
