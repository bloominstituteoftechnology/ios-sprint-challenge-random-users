//
//  User.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User {
    enum UserKeys: String, CodingKey {
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
    
    let name: String
    let email: String
    let phone: String
    let largePictureURL: URL
    let mediumPictureURL: URL
    let thumbnailURL: URL
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        name = "\(title) \(first) \(last)"
        
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        largePictureURL = try pictureContainer.decode(URL.self, forKey: .large)
        mediumPictureURL = try pictureContainer.decode(URL.self, forKey: .medium)
        thumbnailURL = try pictureContainer.decode(URL.self, forKey: .thumbnail)
    }
}
