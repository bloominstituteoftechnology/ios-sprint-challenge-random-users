//
//  Keys.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Keys {
    
    static let userDetailSegue: String = "UserDetailSegue"
    static let userCellID: String = "UserCell"
    
    static let requestURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
}
