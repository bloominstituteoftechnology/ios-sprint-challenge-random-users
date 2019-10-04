//
//  User.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    let thumbnail: String
    let largePhoto: String
    
    
    
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
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let NameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        title = try NameContainer.decode(String.self, forKey: .title)
        first = try NameContainer.decode(String.self, forKey: .first)
        last = try NameContainer.decode(String.self, forKey: .last)
        
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        largePhoto = try pictureContainer.decode(String.self, forKey: .large)
        thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
    }
}

