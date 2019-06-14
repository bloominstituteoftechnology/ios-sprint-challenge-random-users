//
//  Person.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct PeopleResults: Decodable {
    var results: [Person]
}


struct Person: Decodable {
    
    var name: String
    var title: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var thumbnail: String
    var largeImage: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }
    
    
    
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        let name = ("\(title) \(firstName) \(lastName)")
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let largeImage = try pictureContainer.decode(String.self, forKey: .large)
        
        
        
        self.name = name
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.thumbnail = thumbnail
        self.largeImage = largeImage
        
        
    }
    
    
}
