//
//  RandomUser.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Equatable{
    var name: String
    var email: String
    var phone: String
    var largeImageURL: URL?
    var thumbnailImageURL: URL?
}

struct RandomUsers: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case randomUsers = "results"
    }

    var randomUsers: [RandomUser]
}


extension RandomUser: Decodable {
    enum CodingKeys: String, CodingKey {
 
    case name
    case email
    case phone
    case imageURLs = "picture"
   
        
        enum NameCodingKeys: String, CodingKey {
        
            case title
            case first
            case last
        }
        
        
        enum Images: String {
            case thumbnail
            case large
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
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageURLCodingKeys.self , forKey: .imageURLs)
        
        let thumbnail = try imageContainer.decode(String.self, forKey: .thumbnail)
        let large = try imageContainer.decode(String.self, forKey: .large)
        
        let thumbnailURL = URL(string: thumbnail)
        let largeURL = URL(string: large)

        
        self.name = name
        self.email = email
        self.phone = phone
        self.thumbnailImageURL = thumbnailURL
        self.largeImageURL = largeURL
        
        
    }
    
    
}
