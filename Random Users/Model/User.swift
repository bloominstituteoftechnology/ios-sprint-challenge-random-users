//
//  User.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct UsersWrapper: Decodable {
    let results: [User]
}

