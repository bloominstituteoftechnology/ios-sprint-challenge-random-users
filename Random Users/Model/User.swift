//
//  User.swift
//  Random Users
//
//  Created by Lydia Zhang on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let name: String
    let email: String
    let phone: String
    let picture: URL
    
    
    enum ResultKey: String, CodingKey {
        case name, email, phone, picture
        
        enum NameKey: String, CodingKey {
            case first, last
        }
        enum PictureKey: String, CodingKey {
            case large, medium, thumbnail
        }
    }
    
    init(name:String, email: String, phone: String, picture: URL) {
        self.name = name
        self.email = email
        self.phone = phone
        self.picture = picture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKey.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: ResultKey.NameKey.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)

        self.name = "\(firstName) \(lastName)"
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        
        let imageContainer = try container.nestedContainer(keyedBy: ResultKey.PictureKey.self, forKey: .picture)
        self.picture = try imageContainer.decode(URL.self, forKey: .large)
            
    }
}

enum UserKey: String,CodingKey {
    case results
}
struct Users: Codable {
    let results: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKey.self)
        results = try container.decode([User].self, forKey: .results)
    }
}


