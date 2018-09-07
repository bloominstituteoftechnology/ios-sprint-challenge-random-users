//
//  User.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable, Equatable {
    
    var name: String
    var gender: String
    var phone: String
    var email: String
    var pictureUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case phone
        case email
        case image
        case pictureUrl = "picture"
        
        enum PictureCodingKeys: String, CodingKey {
            case medium
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.phone = try container.decode(String.self, forKey: .gender)
        self.email = try container.decode(String.self, forKey: .email)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .pictureUrl)
        self.pictureUrl = try pictureContainer.decode(URL.self, forKey: .medium)
    }
    
}
