//
//  User.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

struct User: Codable {
    let name: String
    let email: String
    let phone: String
    let largeImage: URL
    let thumbNail: URL
    
    enum TopCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PhotoKeys: String, CodingKey {
        case large
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        
        let containter = try decoder.container(keyedBy: TopCodingKeys.self)
        let email = try containter.decode(String.self, forKey: .email)
        let phone = try containter.decode(String.self, forKey: .phone)
        
        let nameContainer = try containter.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let name = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        let photoContainer = try containter.nestedContainer(keyedBy: PhotoKeys.self, forKey: .picture)
        let largeImageString = try photoContainer.decode(String.self, forKey: .large)
        let largeImage = URL(string: largeImageString)!
        let thumbNailString = try photoContainer.decode(String.self, forKey: .thumbnail)
        let thumbNail = URL(string: thumbNailString)!
        
        self.email = email
        self.phone = phone
        self.name = name
        self.largeImage = largeImage
        self.thumbNail = thumbNail
    }
}

struct Results: Codable {
    var results: [User]
}
