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
    
    var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    func getUsers() {
        
    }
}
