//
//  User.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
let name: [String: String]
let email: String
let phone: String
let picture: [String: String]
    
    enum Keys: String, CodingKey {
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
        case thumbnail
        case large
    }
    
    init(from decoder: Decoder) throws {
           
           let values = try decoder.container(keyedBy: Keys.self)
           
           email = try values.decode(String.self, forKey: .email)
           phone = try values.decode(String.self, forKey: .phone)
           
           var name: [String: String] = [:]
           var picture: [String: String] = [:]
           
           let nameContainer = try values.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
           let firstName = try nameContainer.decode(String.self, forKey: .first)
           let lastName = try nameContainer.decode(String.self, forKey: .last)
           let title = try nameContainer.decode(String.self, forKey: .title)
           name["first"] = firstName
           name["last"] = lastName
           name["title"] = title
           
           let pictureContainer = try values.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
           let largePicture = try pictureContainer.decode(String.self, forKey: .large)
           let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
           picture["large"] = largePicture
           picture["thumbnail"] = thumbnail
           
           self.name = name
           self.picture = picture
       }
}

struct FetchResults: Decodable {
    let results: [User]
}
