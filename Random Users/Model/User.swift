//
//  User.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Codable {
    var results: [User]
    
    static var jsonDecoder: JSONDecoder {
        let result = JSONDecoder()
        result.keyDecodingStrategy = .convertFromSnakeCase
        return result
    }
}

struct User: Codable, Hashable {
    let name: Name
    let picture: Picture
    let phone: String
    let email: String
}

struct Name: Codable, Hashable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable, Hashable {
    let large: String
    let thumbnail: String
    let imageURL : URL 
}
