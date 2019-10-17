//
//  User.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResult: Codable {
    let results: [User]
    let info: UserInfo
}

struct UserInfo: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
}
