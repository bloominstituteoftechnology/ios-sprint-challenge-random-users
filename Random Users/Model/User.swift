//
//  User.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct Name: Codable {
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: URL
    let thumbnail: URL
}

