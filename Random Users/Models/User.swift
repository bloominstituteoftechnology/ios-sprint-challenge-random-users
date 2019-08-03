//
//  User.swift
//  Random Users
//
//  Created by Seschwan on 8/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Codable {
    var results: [User]
    
    enum RandomUserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        // Intial Container to grab the overall values of the Results
        let container = try decoder.container(keyedBy: RandomUserKeys.self)
        
        var randomUserArrayContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var arrayOfRandomUsers = [User]() // Create an array to store the values
        
        while !randomUserArrayContainer.isAtEnd {
            let user = try randomUserArrayContainer.decode(User.self)
            arrayOfRandomUsers.append(user)
        }
        results = arrayOfRandomUsers
    }
}

struct User: Codable {
    // Names
    let title: String
    let first: String
    let last:  String
    
    // Contact Info
    let email: String
    let phone: String
    
    // Pictures
    let large: URL
    let thumbnail: URL
    
    enum UserKeys: String, CodingKey {
        case name, email, phone, picture
        
        // Name keys nested values
        enum NameKeys: String, CodingKey {
            case title, first, last
        }
        
        // Picture keys nested values
        enum PictureKeys: String, CodingKey {
            case large, thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        // Intial Container holding these values
        let container = try decoder.container(keyedBy: UserKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        // Getting the name values
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last  = try nameContainer.decode(String.self, forKey: .last)
        
        // Getting the picture values
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        large     = try pictureContainer.decode(URL.self, forKey: .large)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
    }
    
    func ecode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        
        // Encoding the UserKeys
        try container.encode(email.self, forKey: .email)
        try container.encode(phone.self, forKey: .phone)
        
        // Encoding the Names
        var nameContainer = container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        try nameContainer.encode(title.self, forKey: .title)
        try nameContainer.encode(first.self, forKey: .first)
        try nameContainer.encode(last.self, forKey: .last)
        
        // Encoding the pictures
        var pictureContainer = container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        try pictureContainer.encode(large.self, forKey: .large)
        try pictureContainer.encode(thumbnail.self, forKey: .thumbnail)
    }
}
