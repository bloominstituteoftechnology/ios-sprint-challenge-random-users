//
//  User.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    func getName() -> String {
        let fullname = "\(name.title) \(name.first) \(name.last)"
        
        return fullname
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: String
    let thumbnail: String
}

struct UserResults: Codable {
    let results: [User]
}
