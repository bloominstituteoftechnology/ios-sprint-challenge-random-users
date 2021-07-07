//
//  User.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {

    let name: String
    let email: String
    let phoneNumber: String
    let thumbNailImageURL: URL
    let largeImageURL: URL

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber = "phone"
        case imageURL = "picture"

        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }

        enum ImageCodingKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let email = try container.decode(String.self, forKey: .email)
        let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)

        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let name = try nameContainer.decode(String.self, forKey: .first)

        let largeImageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageCodingKeys.self, forKey: .imageURL)
           let largeStr = try largeImageContainer.decode(String.self, forKey: .large)
        let largeImageURL = URL(string: largeStr)

        let thumbNailContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageCodingKeys.self, forKey: .imageURL)
            let thumbStr = try thumbNailContainer.decode(String.self, forKey: .thumbnail)
        let thumbNailURL = URL(string: thumbStr)

        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.thumbNailImageURL = thumbNailURL!
        self.largeImageURL = largeImageURL!




    }
}
