//
//  User.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
    var id: UUID
    
    enum ResultKeys: String, CodingKey {
        case email
        case phone
        case name
        case picture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        name = try container.decode(Name.self, forKey: .name)
        picture = try container.decode(Picture.self, forKey: .picture)
        id = UUID()
    }
}

// MARK: - Name
struct Name: Codable {
    let title: Title
    let first, last: String
}

// MARK: - Title
enum Title: String, Codable {
    case madame = "Madame"
    case mademoiselle = "Mademoiselle"
    case miss = "Miss"
    case monsieur = "Monsieur"
    case mr = "Mr"
    case mrs = "Mrs"
    case ms = "Ms"
}

// MARK: - Picture
struct Picture: Codable {
    let large, thumbnail: String
}
