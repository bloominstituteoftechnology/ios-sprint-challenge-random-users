//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var users: [User] = []
    
    
    func addUsers(addedUsers: [User]) {
        users.append(contentsOf: addedUsers)
    }
}
