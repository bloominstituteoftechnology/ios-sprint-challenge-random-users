//
//  User.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable {
    let results: [User]
}

struct User: Decodable {
    var name: String // name has nested properties: title, first, last
    var email: String
    var phone: String
    var largeImageURL: URL // large is nested in picture
    var thumbnailImageURL: URL // thumbnail is nested in picture
    
    enum UserKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let name = ("\(title.capitalized). \(first.capitalized) \(last.capitalized)")
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        let imageContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        let largeImageURL = try imageContainer.decode(URL.self, forKey: .large)
        let thumbnailImageURL = try imageContainer.decode(URL.self, forKey: .thumbnail)
        
        self.name = name
        self.email = email
        self.phone = phone
        self.largeImageURL = largeImageURL
        self.thumbnailImageURL = thumbnailImageURL
    }
    
}

// JSON result
//"results": [
//    {
//        "name": {
//            "title": "mr",
//            "first": "rolf",
//            "last": "hegdal"
//            },
//        "email": "rolf.hegdal@example.com",
//        "phone": "66976498",
//        "picture": {
//            "large": "https://randomuser.me/api/portraits/men/65.jpg",
//            "thumbnail": "https://randomuser.me/api/portraits/thumb/men/65.jpg"
//            }
//    }
//]
