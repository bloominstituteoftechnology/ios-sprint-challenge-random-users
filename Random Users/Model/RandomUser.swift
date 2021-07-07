//
//  RandomUser.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    let name: String
    let email: String
    let phone: String
    let smallImageURL: URL
    let largeImageURL: URL
    
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
    
    enum PhotoCodingKeys: String, CodingKey {
        case large
        case thumbnail
    }
}

init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let email = try container.decode(String.self, forKey: .email)
    let phone = try container.decode(String.self, forKey: .phone)
    
    let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
    
    let title = try nameContainer.decode(String.self, forKey: .title)
    let first = try nameContainer.decode(String.self, forKey: .first)
    let last = try nameContainer.decode(String.self, forKey: .last)
    
    let name = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
    
    let thumbImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PhotoCodingKeys.self, forKey: .picture)
    
    let smallImageURL = try thumbImageContainer.decode(URL.self, forKey: .thumbnail)
    
    let largeImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PhotoCodingKeys.self, forKey: .picture)
    
    let largeImageURL = try largeImageContainer.decode(URL.self, forKey: .large)
    
    self.name = name
    self.email = email
    self.phone = phone
    self.smallImageURL = smallImageURL
    self.largeImageURL = largeImageURL
    
    }
}


struct Users: Decodable {
    let results: [User]
    
    enum UserCodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let results = try container.decode([User].self, forKey: .results)
        self.results = results
    }
    
}

