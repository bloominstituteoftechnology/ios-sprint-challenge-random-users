//
//  User.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct UserResults: Decodable {
    
    let results: [User]
    
    enum Key: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        results = try container.decode([User].self, forKey: .results)
    }
}

struct User: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKey: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKey: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    var name: String
    var email: String
    var phone: String
    var large: String
    var thumbnail: String
    
    init(name: String, email: String, phone: String, large: String, thumbnail: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.large = large
        self.thumbnail = thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKey.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        name = "\(title) \(first) \(last)"
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureKey.self, forKey: .picture)
        
        large = try imageContainer.decode(String.self, forKey: .large)
        thumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)
    }
    
}

