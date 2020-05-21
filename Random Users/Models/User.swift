//
//  User.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    var results: [User]
}

struct Name: Codable {
    var title: String
    var first: String
    var last: String
    
    var fullName: String {
        return "\(title) \(first) \(last)"
    }
}

struct Picture: Codable {
    var thumbnail: URL
    var large: URL
}

struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}


