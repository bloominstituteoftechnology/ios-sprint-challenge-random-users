//
//  User.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var results: [User]
}
struct User: Decodable {
    var name: String
    var email: String
    var phone: String
    var thumbnailImage: URL
    var largeImage: URL

    enum ContactKeys: String, CodingKey {
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
            case medium
            case thumbnail
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContactKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: ContactKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let pictureContainer = try container.nestedContainer(keyedBy: ContactKeys.PictureKeys.self, forKey: .picture)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)

        name = "\(title) \(first) \(last)"
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)

        thumbnailImage = URL(string: thumbnail)!
        largeImage = URL(string: large)!
    }
}
