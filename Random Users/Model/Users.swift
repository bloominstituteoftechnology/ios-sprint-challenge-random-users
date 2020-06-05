//
//  Users.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable {
    let name: Names
    let email: String
    let phone: String
    let picture: Images
}

struct UserWrapper: Decodable {
    let results: [Users]
}
