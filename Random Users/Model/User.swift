//
//  User.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


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


struct User: Equatable, Decodable {
    enum Keys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title, first, last
        }
        
        enum PictureKeys: String, CodingKey{
            case large, thumbnail
        }
    }
        let name: String
        let email: String
        let phone: String
        let thumbnailPic: URL
        let largePic: URL
    
    init(name: String, email: String, phone: String, thumbnailPic: URL, largePic: URL) {
        self.name = name
        self.email = email
        self.phone = phone
        self.thumbnailPic = thumbnailPic
        self.largePic = largePic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: Keys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        
        let pictureContainer = try container.nestedContainer(keyedBy: Keys.PictureKeys.self, forKey: .picture)
        
        self.thumbnailPic = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        self.largePic = try pictureContainer.decode(URL.self, forKey: .large)
    }
}
