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
    var picture: String
    
    enum PersonCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case first
        case last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case large
    }
}

extension Person {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonCodingKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        name = try nameContainer.decode(String.self, forKey: .first) + " " + nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        picture = try pictureContainer.decode(String.self, forKey: .large)
    }
}
