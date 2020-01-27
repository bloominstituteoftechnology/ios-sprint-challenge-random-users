//
//  UserController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    var friends: [Friend] = []
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    
}
