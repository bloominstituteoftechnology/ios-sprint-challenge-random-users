//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    private(set) var users: [User] = []
    
    func addUsers(newUser addedUsers: [User]) {
        users.append(contentsOf: addedUsers)
    }
}
