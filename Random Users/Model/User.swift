//
//  User.swift
//  Random Users
//
//  Created by Joel Groomer on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var title: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var thumbnail: URL
    var pictureMedium: URL
    var pictureLarge: URL
    
    enum UserKeys: String, CodingKey {
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
    
    enum PictureKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        
        title = try nameContainer.decode(String.self, forKey: .title)
        firstName = try nameContainer.decode(String.self, forKey: .first)
        lastName = try nameContainer.decode(String.self, forKey: .last)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        pictureMedium = try pictureContainer.decode(URL.self, forKey: .medium)
        pictureLarge = try pictureContainer.decode(URL.self, forKey: .large)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        var nameContainer = container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        var pictureContainer = container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        
        try nameContainer.encode(title, forKey: .title)
        try nameContainer.encode(firstName, forKey: .first)
        try nameContainer.encode(lastName, forKey: .last)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try pictureContainer.encode(thumbnail, forKey: .thumbnail)
        try pictureContainer.encode(pictureMedium, forKey: .medium)
        try pictureContainer.encode(pictureLarge, forKey: .large)
    }
}
