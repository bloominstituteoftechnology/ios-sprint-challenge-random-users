//
//  User.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let name: Name
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    let email: String
    let phone: String
    
    let picture: Picture
    struct Picture: Codable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }
    
    var fullName: String {
        "\(name.title) \(name.first) \(name.last)"
    }
}

struct UserResult: Codable {
    
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
    }
}
