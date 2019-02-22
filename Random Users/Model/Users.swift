//
//  Users.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable {
    var title: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var thumbnail: String
    var large: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }
    
    
    init(from decoder: Decoder) throws {
        //create a cotainer
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.large = large
        self.thumbnail = thumbnail
    }
}


struct UserResults: Decodable {
    
    var results: [Users]
}
