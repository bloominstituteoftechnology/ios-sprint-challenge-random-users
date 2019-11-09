//
//  Person.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


struct Person: Codable {
    var name: String
    var email: String
    var phone: String
    var picture: URL
    
    enum PersonCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
        }
    }
}

extension Person {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonCodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: PersonCodingKeys.NameCodingKeys.self, forKey: .name)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        name = "\(first) \(last)"
        
        let pictureContainer = try container.nestedContainer(keyedBy: PersonCodingKeys.PictureCodingKeys.self, forKey: .picture)
        picture = try pictureContainer.decode(URL.self, forKey: .large)
    }
}

struct People: Codable {
    var people: [Person]
    
    enum PeopleKeys: String, CodingKey {
        case people
    }
}

extension People {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PeopleKeys.self)
        people = try container.decode([Person].self, forKey: .people)
    }
}
