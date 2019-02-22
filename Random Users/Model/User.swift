//
//  User.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    
    let name: String
    let email: String
    let phone: String
    let imageURL: URL
    let largeImageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case imageURL = "picture"
        case largeImageURL
        
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
    
    // MARK: - DECODER
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        let name = "\(title) \(first) \(last)"
        
        let smallImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .imageURL)
        let imageURL = try smallImageContainer.decode(URL.self, forKey: .thumbnail)
        
        let largeImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .largeImageURL)
        let largeImageURL = try largeImageContainer.decode(URL.self, forKey: .large)
        
        (self.name, self.email, self.phone, self.imageURL, self.largeImageURL) = (name, email, phone, imageURL, largeImageURL)
    }
}

struct Users: Decodable {
    let results: [User]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([User].self, forKey: .results)
        self.results = results
    }
}
