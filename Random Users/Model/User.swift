//
//  User.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    
    let users: [User]
    
    enum CodingKeys: String,CodingKey {
        case users = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.users = try container.decode([User].self, forKey: .users)
    }
    
}


struct User : Decodable  {
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String,CodingKey {
            case title
            case first
            case last
        }
        enum PictureCodingKeys: String,CodingKey {
            case large
            case thumbnail
        }
        
    }
    
    
    let name : String
    let email: String
    let phoneNumber : String
    let largeImage : URL
    let thumbNailImage: URL
    
    init(name: String, email: String , phoneNumber: String , largeImage: URL, thumbNailImage: URL) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.largeImage = largeImage
        self.thumbNailImage = thumbNailImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        self.name = title + " " + firstName + " " + lastName
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phoneNumber = try container.decode(String.self, forKey: .phone)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        
         let largeImageString = try pictureContainer.decode(String.self, forKey: .large)
        self.largeImage = URL(string: largeImageString)!
        
        
        let thumbNailImageString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        self.thumbNailImage = URL(string: thumbNailImageString)!
   
        
}
    
}
