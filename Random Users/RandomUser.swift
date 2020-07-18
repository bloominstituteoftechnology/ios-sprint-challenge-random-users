//
//  RandomUser.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


struct User: Equatable, Decodable {
    let name: String
    let phone: String
    let email: String
    let thumbnail: URL
    let image: URL
    
    init(name: String, phone: String, email: String, thumbnail: URL, image: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnail = thumbnail
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case name, phone, email, picture
        
        enum ImageKey: String, CodingKey {
            case thumbnail, large
        }
        
        enum NameKey: String, CodingKey {
            case title, first, last
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKey.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        name = "\(title) \(first) \(last)"
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        
        let thumbnailContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKey.self, forKey: .picture)
        
        thumbnail = try thumbnailContainer.decode(URL.self, forKey: .thumbnail)
        
        let largeImageContainer =  try container.nestedContainer(keyedBy: CodingKeys.ImageKey.self, forKey: .picture)
        image = try largeImageContainer.decode(URL.self, forKey: .large)
    }
}

struct Users: Decodable {
    let results: [User]
    
    enum UserKey: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKey.self)
        results = try container.decode([User].self, forKey: .results)
    }
}

