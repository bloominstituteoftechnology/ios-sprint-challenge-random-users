//
//  User.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


struct Results: Codable {
    var results: [User]
}

struct User: Codable {
    let name: Name
    let picture: Picture
    let phone: String
    let email: String
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: URL
    let thumbnail: URL
}
