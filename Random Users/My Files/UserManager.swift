//
//  UserManager.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserManager {
    
    static var shared = UserManager()

    
    var addressbook: [User] = []
    
    func createUser(infoFromAPI: User) {
        
    let tempUser = infoFromAPI
        
    addressbook.append(tempUser)
        
    
    }
    
    
    
}
