//
//  User.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let results: [User]
    
    enum ResultsCodingKey: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsCodingKey.self)
        
        self.results = try container.decode([User].self, forKey: .results)
    }
}

struct User: Decodable {
    let name: String
    let phone: String
    let email: String
    let thumbnail: String
    let photo: String
    
    enum UserCodingKeys: String, CodingKey {
        case name, phone, email, thumbnail, photo, picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case first, last
    }
    
    enum PictureContainerCodingKeys: String, CodingKey {
        case large, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        self.name = "\(first) \(last)"
        
        let photosContainer = try container.nestedContainer(keyedBy: PictureContainerCodingKeys.self, forKey: .picture)
        
        self.thumbnail = try photosContainer.decode(String.self, forKey: .thumbnail)
        self.photo = try photosContainer.decode(String.self, forKey: .large)
    }
}
