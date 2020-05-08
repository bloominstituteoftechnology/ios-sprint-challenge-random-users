//
//  User.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        return "\(title) \(first) \(last)"
    }
}

struct Picture: Codable {
    let large: String
    let thumbnail: String
}
