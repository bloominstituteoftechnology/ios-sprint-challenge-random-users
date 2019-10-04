//
//  RandomUser.swift
//  Random Users
//
//  Created by Jordan Christensen on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UsersList: Codable {
    let results: [RandomUser]
}

struct RandomUser: Codable {
    let name: Name
    let email: String
    let phone: String
    let cell: String
    let picture: Pictures
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Pictures: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
