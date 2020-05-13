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
    var title: String
    var phone: String
    var email: String
    var pictureUrl: URL
    var id: String = UUID().uuidString
    var picture: Data?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case email
        case image
        case pictureUrl = "picture"
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
            case title
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        self.title = try nameContainer.decode(String.self, forKey: .title)
        self.name = "\(firstName) \(lastName)"
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .pictureUrl)
        self.pictureUrl = try pictureContainer.decode(URL.self, forKey: .large)
    }
    
}

struct Users: Decodable, Equatable {
    
    let results: [User]
    
}
