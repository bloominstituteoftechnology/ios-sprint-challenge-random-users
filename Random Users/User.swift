//
//  RandomUser.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Name: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }

    let title: String // mr
    let first: String // brad
    let last: String // gibson
    
    var fullName: String {
        return ("\(title) \(first) \(last)").trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

struct Picture: Codable {
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }

    let large: String // https://randomuser.me/api/portraits/men/75.jpg
    let medium: String // https://randomuser.me/api/portraits/med/men/75.jpg
    let thumbnail: String // https://randomuser.me/api/portraits/thumb/men/75.jpg
}

struct User: Codable {

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }

    let name: Name

    let email: String // brad.gibson@example.com
    let phone: String // 011-962-7516

    let picture: Picture
}

struct UsersFromServer: Codable {
    let results: [User]
}

