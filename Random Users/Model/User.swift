//
//  User.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResult: Decodable {
    enum CodingKeys: String, CodingKey {
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

    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case imageURLs = "picture"

        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }

        enum ImageURLCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)

        let name = "\(title) \(first) \(last)"


        let phoneNumber = try container.decode(String.self, forKey: .phone)
        let emailAddress = try container.decode(String.self, forKey: .email)

        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageURLCodingKeys.self, forKey: .imageURLs)
        let thumbnailString = try imageContainer.decode(String.self, forKey: .thumbnail)
        let largeString = try imageContainer.decode(String.self, forKey: .large)

        let thumbnailImageURL = URL(string: thumbnailString)
        let largeImageURL = URL(string: largeString)

        self.name = name
        self.phone = phoneNumber
        self.email = emailAddress
        self.thumbnail = thumbnailImageURL
        self.large = largeImageURL
    }
}

