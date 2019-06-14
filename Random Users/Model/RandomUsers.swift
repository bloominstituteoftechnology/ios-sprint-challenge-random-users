//
//  RandomUsers.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

import Foundation

struct RandomUsers: Codable {
    let results: [Result]
}

struct Result: Codable, Comparable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture

    static func ==(lhs: Result, rhs: Result) -> Bool {
        return lhs.name.first == rhs.name.first
    }

    static func <(lhs: Result, rhs: Result) -> Bool {
        return lhs.name.first < rhs.name.first
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
