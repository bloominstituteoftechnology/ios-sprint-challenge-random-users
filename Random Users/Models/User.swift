//
//  User.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let email: String
    let phone: String
    let picture: Picture
    var id: UUID
    
    enum ResultKey: String, CodingKey {
        case name, email, phone, picture
    
    enum NameKey: String, CodingKey {
        case first, last
        }
    }
    
    struct Picture: Codable {
        let large, thumbnail: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKey.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: ResultKey.NameKey.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        self.name = "\(firstName) \(lastName)"
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.picture = try container.decode(Picture.self, forKey: .picture)
        id = UUID()
    }
}

struct Users: Codable {
    let results: [User]
    
    enum UsersKey: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersKey.self)
        results = try container.decode([User].self, forKey: .results)
    }
}
