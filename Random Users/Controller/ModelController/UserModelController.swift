//
//  UserModelController.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserModelController {
    
    static let shared = UserModelController()
    private let randomUsersQueue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.UserControllerQueue")
       private(set) var users: [User] {
           get {
               return randomUsersQueue.sync { secondaryUsers }
           }
           set {
               randomUsersQueue.async { self.secondaryUsers = newValue }
           }
       }
    private var secondaryUsers: [User] = []
    private init() {}
    
    func addUsers(addedUsers: [User]) {
        users.append(contentsOf: addedUsers)
    }
    
    
}

