//
//  User.swift
//  Random Users
//
//  Created by Daniela Parra on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    
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
        
        let fullName = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        
        let thumbnailString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let thumbnailURL = URL(string: thumbnailString)!
        
        let fullSizeString = try pictureContainer.decode(String.self, forKey: .large)
        let fullSizeURL = URL(string: fullSizeString)!
        
        self.email = email
        self.phone = phone
        self.name = fullName
        self.thumbnailURL = thumbnailURL
        self.fullSizeURL = fullSizeURL
    }
    
    let name: String
    let email: String
    let phone: String
    let thumbnailURL: URL
    let fullSizeURL: URL
    
}

struct Results: Decodable {
    let results: [User]
}
