//
//  User.swift
//  Random Users
//
//  Created by Aaron Cleveland on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Equatable, Decodable {
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    init(name: String,
         phone: String,
         email: String,
         thumbnailImage: URL,
         largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum ImageKeys: String, CodingKey {
            case large, thumbnail
            
        }
        
        enum NameKeys: String, CodingKey {
            case title, first, last
        }
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self,
                                                          forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(title) \(firstName) \(lastName)"
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        
        let thumbnailImageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self,
                                                                    forKey: .picture)
        self.thumbnailImage = try thumbnailImageContainer.decode(URL.self, forKey: .thumbnail)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self,
                                                           forKey: .picture)
        self.largeImage = try imageContainer.decode(URL.self, forKey: .large)
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
