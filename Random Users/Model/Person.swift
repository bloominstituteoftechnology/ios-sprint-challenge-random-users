//
//  Person.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


struct Person: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    enum PersonCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonCodingKeys.self)
        name = try container.decode(Name.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        picture = try container.decode(Picture.self, forKey: .picture)
    }
}

struct Name: Codable {
    var first: String
    var last: String
    
    enum NameCodingKeys: String, CodingKey {
        case first
        case last
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NameCodingKeys.self)
        first = try container.decode(String.self, forKey: .first)
        last = try container.decode(String.self, forKey: .last)
    }
}

struct Picture: Codable {
    var large: String
    
    enum PictureCodingKeys: String, CodingKey {
        case large
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PictureCodingKeys.self)
        large = try container.decode(String.self, forKey: .large)
    }
}
