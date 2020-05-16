//
//  User.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var results: [Results]
}

struct User: Decodable {
    var name: String
    var email: String
    var phone: String
    var thumbnail: URL
    var picture: [URL]
    var largePicture: URL

    
enum UserResultKeys: String, CodingKey {
    case name
    case phone
    case email
    case picture
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
        let container = try decoder.container(keyedBy: UserResultKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        var pictureURLS: [URL] = []
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let large = try pictureContainer.decode(String.self, forKey: .large)



        if let thumbnailURL = URL(string: thumbnail),
            let largeURL = URL(string: large) {
            pictureURLS.append(thumbnailURL)
            pictureURLS.append(largeURL)
        }

        self.name = "\(title) \(first) \(last)"
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        self.picture = pictureURLS
        self.thumbnail = URL(string: thumbnail)!
        self.largePicture = URL(string: large)!

        
    }
}
