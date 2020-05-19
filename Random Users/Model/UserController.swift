//
//  UserController.swift
//  Random Users
//
//  Created by Breena Greek on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserController {
    
     static let shared = UserController()
        private init() {}
        
        func addUsers(_ newUsers: [User]) {
            users.append(contentsOf: newUsers)
        }
        
        private var _users: [User] = []
        private(set) var users: [User] { 
            get {
                return accessQueue.sync { _users }
            }
            set {
                accessQueue.async { self._users = newValue }
            }
        }
        private let accessQueue = DispatchQueue(label: "com.RandomUsers.UserControllerQueue")
    }
