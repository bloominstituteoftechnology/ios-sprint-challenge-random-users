//
//  User.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Decodable {
    let results: [User]
}

struct User: Decodable {
    let name: [String: String]
    let email: String
    let phone: String
    let picture: [String: String]
    
    
    //Enums for Coding Keys
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        
        var name: [String: String] = [:]
        var picture: [String: String] = [:]
        
        let nameFromContainer = try values.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        let firstName = try nameFromContainer.decode(String.self, forKey: .first)
        let lastName = try nameFromContainer.decode(String.self, forKey: .last)
        let title = try nameFromContainer.decode(String.self, forKey: .title)
        name["first"] = firstName
        name["last"] = lastName
        name["title"] = title
        
        let pictureFromContainer = try values.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        let largePicture = try pictureFromContainer.decode(String.self, forKey: .large)
        let thumbnail = try pictureFromContainer.decode(String.self, forKey: .thumbnail)
        picture["thumbnail"] = thumbnail
        picture["large"] = largePicture
        
        self.name = name
        self.picture = picture
    }
}
