//
//  User.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    enum CodingKeys: String, CodingKey{
        case users = "results"
    }
    var users: [User]
}

struct User: Equatable {
    var name: String
    var email: String?
    var phone: String
    var thumbnail: URL?
    var large: URL?
}

extension User: Decodable {
    enum Images: String {
        case thumbnail
        case large
    }

    enum UserCodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case imageURLS = "picture"

        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }

        enum ImageCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }

    init(from decoder: Decoder) throws {

        // UserCodingKeys
        let container = try decoder.container(keyedBy: UserCodingKeys.self)

        //NameCodingKeys
        let nameContainer = try container.nestedContainer(keyedBy: UserCodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)

        //ImageCodingKeys
        let imageContainer = try container.nestedContainer(keyedBy: UserCodingKeys.ImageCodingKeys.self, forKey: .imageURLS)
        let thumbnailImageString = try imageContainer.decode(String.self, forKey: .thumbnail)
        let largeImageString = try imageContainer.decode(String.self, forKey: .large)
        let thumbnailImage = URL(string: thumbnailImageString)
        let largeImage = URL(string: largeImageString)

        self.name = "\(title) \(first) \(last)"
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        self.thumbnail = thumbnailImage
        self.large = largeImage
    }
}


