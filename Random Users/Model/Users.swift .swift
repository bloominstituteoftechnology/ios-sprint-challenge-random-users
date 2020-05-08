//
//  Users.swift .swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
}

struct Name: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    let title: String
    let first: String
    let last: String
    
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
    let large: String
    let medium: String
    let thumbnail: String
    
}

struct UserResult: Codable {
let results: [User]
}
