//
//  UsersController.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data Source
    var users = [User]()
    let fetchUsersOperation = FetchUsersOperation()
    let userQueue = OperationQueue()
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup Functions
    func fetchUsers(completion: @escaping () -> ()) {
        let completionOperation = BlockOperation {
            if let users = self.fetchUsersOperation.users {
              self.users = users
            }
            completion()
        }
        
        userQueue.addOperation(fetchUsersOperation)
        completionOperation.addDependency(fetchUsersOperation)
        OperationQueue.main.addOperation(completionOperation)
    }
}
