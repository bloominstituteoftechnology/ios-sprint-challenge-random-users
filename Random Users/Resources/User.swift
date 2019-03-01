//
//  User.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Decodable {
    
    let name: [String: String]
    let email: String
    let phone: String
    let picture: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    private enum NameCodingKeys: String, CodingKey {
        case first
        case last
    }
    
    private enum PictureCodingKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
}

extension Result {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        email = try values.decode(String.self, forKey: .email)
        phone = try values.decode(String.self, forKey: .phone)
        
        var name: [String: String] = [:]
        var picture: [String: String] = [:]
        
        let nestedName = try values.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        let firstName = try nestedName.decode(String.self, forKey: .first)
        let lastName = try nestedName.decode(String.self, forKey: .last)
        
        name["first"] = firstName
        name["last"] = lastName
        
        let nestedPicture = try values.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        let largePic = try nestedPicture.decode(String.self, forKey: .large)
        let thumbnail = try nestedPicture.decode(String.self, forKey: .thumbnail)
        
        picture["thumbnail"] = thumbnail
        picture["large"] = largePic
        
        self.name = name
        self.picture = picture
    }
    
    
}

struct UserResults: Decodable {
    
    let results: [Result]
}
