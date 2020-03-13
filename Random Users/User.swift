//
//  User.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Codable {
    var name: String
    var picture: URL
    var email: String
    var phone: String
    
    enum UserKeys: String, CodingKey {
        case name
        case picture
        case email
        case phone
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let picContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        name = "\(title) \(first) \(last)"
        picture = try picContainer.decode(URL.self, forKey: .thumbnail)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
    }
}

struct UserResults: Codable {
    let results: [User]
}
