//
//  User.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class User: Decodable {
    var title: String
    var first: String
    var last: String
    var email: String
    var phone: String
    var thumbnailImage: URL
    var largeImage: URL
    
    enum UserCodingKeys: String, CodingKey {
        case name, email, phone, picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title, first, last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case large, thumbnail
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        
        let thumbnailImageString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let thumbnailImageURL = URL(string: thumbnailImageString)!
        
        let largeImageString = try pictureContainer.decode(String.self, forKey: .large)
        let largeImageURL = URL(string: largeImageString)!
        
        self.title = title
        self.first = first
        self.last = last
        self.email = email
        self.phone = phone
        self.thumbnailImage = thumbnailImageURL
        self.largeImage = largeImageURL
    }
}
