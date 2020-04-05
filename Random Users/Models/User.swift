//
//  User.swift
//  Random Users
//
//  Created by Gerardo Hernandez on 4/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

//MARK: - Nested JSON
struct Name: Codable {
    var title: String
    var first: String
    var last: String
    var fullName: String { "\(title) \(first) \(last)" }
}

struct Picture: Codable {
    var large, medium, thumbnail: URL
}


