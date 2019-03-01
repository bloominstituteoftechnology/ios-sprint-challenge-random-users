//
//  User.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let results: [User]
}

struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    struct Name: Decodable {
        var title: String
        var first: String
        var last: String
    }
    
    struct Picture: Decodable {
        var large: String
        var thumbnail: String
    }
    
//    required init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: UserCodingKeys.self)
//
//        let email = try container.decode(String.self, forKey: .email)
//        let phone = try container.decode(String.self, forKey: .phone)
//
//        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
//
//        let title = try nameContainer.decode(String.self, forKey: .title)
//        let first = try nameContainer.decode(String.self, forKey: .first)
//        let last = try nameContainer.decode(String.self, forKey: .last)
//
//        let pictureContainer = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
//
//        let thumbnailImageString = try pictureContainer.decode(String.self, forKey: .thumbnail)
//        let thumbnailImageURL = URL(string: thumbnailImageString)!
//
//        let largeImageString = try pictureContainer.decode(String.self, forKey: .large)
//        let largeImageURL = URL(string: largeImageString)!
//
//        self.name = nameContainer
//        self.email = email
//        self.phone = phone
//        self.thumbnailImage = thumbnailImageURL
//        self.largeImage = largeImageURL
//    }
}
