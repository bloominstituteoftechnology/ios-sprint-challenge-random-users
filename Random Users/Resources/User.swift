//
//  Users.swift
//  Random Users
//
//  Created by Moses Robinson on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    
    var name: String
    var phone: String?
    var email: String?
    var largeImage: URL?
    
    enum Images: String {
        case large
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum ImageCodingKeys: String, CodingKey {
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let name = "\(title) \(first) \(last)"
        
        let phone = try container.decode(String.self, forKey: .phone)
        let email = try container.decode(String.self, forKey: .email)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageCodingKeys.self, forKey: .picture)
        let largeString = try imageContainer.decode(String.self, forKey: .large)
        
        let largeImage = URL(string: largeString)
        
        self.name = name
        self.phone = phone
        self.email = email
        self.largeImage = largeImage
    }
    
}

struct Users: Decodable {
    
    var users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
    }
    
}

