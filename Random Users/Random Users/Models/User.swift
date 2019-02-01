//
//  User.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation

struct Result: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email, cell: String
    let picture: Picture
    let id: ID
}

struct Name: Codable {
    let title, first, last: String
}

struct ID: Codable {
    let value: String
}

struct Picture: Codable {
    let large, medium, thumbnail: String
}
