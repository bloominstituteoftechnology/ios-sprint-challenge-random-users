//
//  User.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

struct UserResults: Codable {
    let results: [User]
}

enum ImageType {
    case large
    case thumbnail
}

struct User: Codable {
    
    enum Keys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    var first: String
    var last: String
    var phone: String
    var email: String
    var large: String
    var thumbnail: String
    
    init(_ first: String, _ last: String, _ phone: String, _ email: String, _ large: String, _ thumbnail: String) {
        self.first = first
        self.last = last
        self.phone = phone
        self.email = email
        self.large = large
        self.thumbnail = thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: Keys.NameKeys.self, forKey: .name)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        
        let imageContainer = try container.nestedContainer(keyedBy: Keys.PictureKeys.self, forKey: .picture)
        large = try imageContainer.decode(String.self, forKey: .large)
        thumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)
    }
}
