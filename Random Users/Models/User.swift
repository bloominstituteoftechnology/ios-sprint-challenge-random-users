//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    
    enum PersonKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        self.name = try container.decode(Name.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.picture = try container.decode(Picture.self, forKey: .picture)
    }
}

struct Name: Codable {
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    enum PictureKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    let large: String
    let medium: String
    let thumbnail: String
}

struct Results: Codable {
    enum ResultKey: String, CodingKey {
        case results
    }
    
    var results: [User]
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ResultKey.self)
        var userContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var tempUsers = [User]()
        while !userContainer.isAtEnd {
            let user = try userContainer.decode(User.self)
            tempUsers.append(user)
        }
        self.results = tempUsers
    }
}
