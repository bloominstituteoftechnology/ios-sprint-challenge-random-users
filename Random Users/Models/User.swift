//
//  User.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResult: Codable {
    let results: [User]
    let info: UserInfo
}

struct UserInfo: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

struct User: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
//    init(name: Name, email: String, phone: String, picture: Picture) {
//        self.name = name
//        self.email = email
//        self.phone = phone
//        self.picture = picture
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let name = try container.decode(Name.self, forKey: .name)
//        let email = try container.decode(String.self, forKey: .email)
//        let phone = try container.decode(String.self, forKey: .phone)
//        let picture = try container.decode(Picture.self, forKey: .name)
//
//
//
//        self.name = name
//        self.email = email
//        self.phone = phone
//        self.picture = picture
//    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
//    init(title: String, first: String, last: String) {
//        self.title = title
//        self.first = first
//        self.last = last
//    }
//
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let title = try container.decode(String.self, forKey: .title)
//        let first = try container.decode(String.self, forKey: .first)
//        let last = try container.decode(String.self, forKey: .last)
//
//        self.title = title
//        self.first = first
//        self.last = last
//    }
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }

    
//    init(large: String, medium: String, thumbnail: String) {
//        self.large = large
//        self.medium = medium
//        self.thumbnail = thumbnail
//    }
//
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let large = try container.decode(String.self, forKey: .large)
//        let medium = try container.decode(String.self, forKey: .medium)
//        let thumbnail = try container.decode(String.self, forKey: .thumbnail)
//
//        self.large = large
//        self.medium = medium
//        self.thumbnail = thumbnail
//    }
}
