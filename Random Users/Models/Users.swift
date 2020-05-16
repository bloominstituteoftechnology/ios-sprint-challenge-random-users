//
//  Users.swift
//  Random Users
//
//  Created by patelpra on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Equatable, Decodable {
    enum Keys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case first, last
        }
        
        enum ImageKeys: String, CodingKey {
            case large, thumbnail
        }
    }
    
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    init(name: String, phone: String, email: String, thumbnailImage: URL, largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }
}

struct Users: Decodable {
    let results: [User]
    
    enum UserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        self.results = try container.decode([User].self, forKey: .results)
    }
}

