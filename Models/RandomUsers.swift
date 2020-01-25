//
//  RandomUsers.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUsers: Codable {
    let name: Name
    let phone: String
    let email: String
    let picture: Picture

    
    init(name: Name, picture: Picture, phone: String, email: String) {
        self.name = name
        self.phone = phone
        self.email = email
        self.picture = picture
    }
    

    enum RandomUserKeys: String, CodingKey {
        case name = "name"
        case phone = "phone"
        case email = "email"
        case picture = "picture"
    }
    
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    enum nameKeys: String, CodingKey {
        case title = "title"
        case first = "first"
        case last = "last"
    }
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
    
    enum pictureKeys: String, CodingKey {
        case thumbnail = "thumbnail"
        case medium = "medium"
        case large = "large"
    }
}

