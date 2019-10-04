//
//  Person.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct People: Codable {
    let results: [Person]
}

class Person: Codable {
    let name: [String]
    let email: String
    let phone: String
    let picture: [String]
    
    enum PersonKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    init?(name: [String], email: String, phone: String, picture: [String]) {
        self.name = name
        self.email = email
        self.phone = phone
        self.picture = picture
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        var nameContainer = try container.nestedUnkeyedContainer(forKey: .name)
        
        var names: [String] = []
        
        while !nameContainer.isAtEnd {
            let name2Container = try nameContainer.nestedContainer(keyedBy: PersonKeys.NameKeys.self)
            let name = try name2Container.decode(String.self, forKey: .first)
            names.append(name)
        }
        self.name = names
        
        var pictures: [String] = []
        
        var pictureContainer = try container.nestedUnkeyedContainer(forKey: .picture)
        
        while pictureContainer.isAtEnd {
            let picture2Container = try pictureContainer.nestedContainer(keyedBy: PersonKeys.PictureKeys.self)
            let pictureURL = try picture2Container.decode(String.self, forKey: .large)
            pictures.append(pictureURL)
        }
        self.picture = pictures
    }
}

