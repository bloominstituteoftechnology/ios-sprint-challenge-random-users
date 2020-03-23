//
//  User.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

// MARK: - Nested Objects

struct Name: Codable {
    var title, first, last: String
    var full: String { "\(title) \(first) \(last)" }
}

struct Picture: Codable {
    var large, medium, thumbnail: URL
}
