//
//  User.swift
//  Random Users
//
//  Created by conner on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: Name
    let phone: String
    let email: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    var displayName: String {
        return "\(title) \(first) \(last)"
    }
}

struct Picture: Codable {
    let large: String
    let thumbnail: String
}

struct Results: Codable {
    let results: [User]
}
