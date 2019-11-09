//
//  People.swift
//  Random Users
//
//  Created by Dillon P on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


struct People: Codable {
    let results: [Person]
}

struct Person: Codable {
    let name: String
    let email: String
    let phone: String
    let pictureURL: String
    
    
    enum PersonKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureKeys: String, CodingKey {
        case large
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        
        var fullNameAndTitle: String = ""
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        fullNameAndTitle = "\(title) + \(first) + \(last)"
        self.name = fullNameAndTitle
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        
        self.pictureURL = try pictureContainer.decode(String.self, forKey: .large)
        
    }
}
