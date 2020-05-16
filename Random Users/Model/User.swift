//
//  User.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User : Codable {
    
    let name: Name
    let picture: Thumbnail
    let phone: String
    let email: String
    
    struct Name : Codable {
        let title: String
        let first: String
        let last: String
        var fullName: String { "\(title). \(first) \(last)" }
    }
    
    struct Thumbnail : Codable {
        let large: URL
        let medium: URL
        let thumnail: URL
    }
}

struct UserResults: Codable {
    var results: [User]
}
